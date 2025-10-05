//
//  CoreDataManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/15.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    fileprivate var persistentContainer: NSPersistentCloudKitContainer!
    
    private init() { initializePersistentContainer() }
    
    private func initializePersistentContainer() {
        persistentContainer = NSPersistentCloudKitContainer(name: "Att")
        
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch { print("SAVE NON COMPLETE:", error as NSError) }
            }
        }
    }
}

#if DEBUG
// MARK: UnitTest용 Initializer
extension CoreDataManager {
    convenience init(testContainer: NSPersistentCloudKitContainer) {
        self.init()
        self.persistentContainer = testContainer
    }
}
#endif

// MARK: - Track / TrackSource Finder & Upsert
private extension CoreDataManager {
    /// Track 존재 여부를 (vendor+vendorTrackId) → isrc → title+artist 순서로 판단.
    /// 동일 Track이 없으면 새로 생성하고, TrackSource는 vendor 기준으로 upsert.
    func findTrack(by music: Music, source: MusicSource?, in context: NSManagedObjectContext) -> Track? {
        
        func isEqualIgnoreCase(_ lhs: String?, _ rhs: String?) -> Bool {
            (lhs ?? "").caseInsensitiveCompare(rhs ?? "") == .orderedSame
        }
        
        var orPredicates: [NSPredicate] = []
        
        // 1) vendor + vendorTrackId
        if let vendorName = source?.musicVendor.rawValue,
           let vendorTrackId = source?.vendorTrackId {
            let predicate = NSPredicate(
                format: "SUBQUERY(sources, $src, $src.vendor == %@ AND $src.vendorTrackId == %@).@count > 0",
                vendorName, vendorTrackId
            )
            orPredicates.append(predicate)
        }
        
        // 2) title + artist
        let predicateTitleArtist = NSPredicate(
            format: "title ==[cd] %@ AND primaryArtistName ==[cd] %@",
            music.title, music.artist
        )
        orPredicates.append(predicateTitleArtist)
        
        // 3) ISRC
        if let isrcCode = source?.isrc, !isrcCode.isEmpty {
            let predicateTrack = NSPredicate(format: "isrc == %@", isrcCode)
            let predicateSource = NSPredicate(
                format: "SUBQUERY(sources, $src, $src.isrc == %@).@count > 0",
                isrcCode
            )
            orPredicates.append(contentsOf: [predicateTrack, predicateSource])
        }
        
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        fetchRequest.fetchLimit = 10
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: orPredicates)
        
        let candidateTracks = (try? context.fetch(fetchRequest)) ?? []
        
        if let vendorName = source?.musicVendor.rawValue,
           let vendorTrackId = source?.vendorTrackId {
            if let matchedTrack = candidateTracks.first(where: {
                guard let trackSources = $0.sources as? Set<TrackSource> else { return false }
                return trackSources.contains { trackSource in
                    trackSource.vendor == vendorName && trackSource.vendorTrackId == vendorTrackId
                }
            }) {
                return matchedTrack
            }
        }
        
        if let isrcCode = source?.isrc, !isrcCode.isEmpty {
            if let matchedTrack = candidateTracks.first(where: { track in
                let isISRCMatch =
                track.isrc == isrcCode ||
                ((track.sources as? Set<TrackSource>)?.contains(where: { $0.isrc == isrcCode }) == true)
                return isISRCMatch
                && isEqualIgnoreCase(track.title, music.title)
                && isEqualIgnoreCase(track.primaryArtistName, music.artist)
            }) {
                return matchedTrack
            }
        }
        
        if let matchedTrack = candidateTracks.first(where: { track in
            isEqualIgnoreCase(track.title, music.title) &&
            isEqualIgnoreCase(track.primaryArtistName, music.artist)
        }) {
            return matchedTrack
        }
        
        return nil
    }
    
    @discardableResult
    func upsertTrackAndSource(
        music: Music,
        source: MusicSource?,
        in context: NSManagedObjectContext
    ) -> Track {
        // 1) Track 찾기 또는 새로 생성
        let existingTrack = findTrack(by: music, source: source, in: context)
        let track = existingTrack ?? Track(context: context)
        track.apply(from: music)
        
        // 2) TrackSource upsert
        if let sourceInfo = source {
            let fetchSourceRequest: NSFetchRequest<TrackSource> = TrackSource.fetchRequest()
            fetchSourceRequest.fetchLimit = 1
            fetchSourceRequest.predicate = NSPredicate(
                format: "vendor == %@ AND vendorTrackId == %@",
                sourceInfo.musicVendor.rawValue, sourceInfo.vendorTrackId
            )
            
            let existingSource = try? context.fetch(fetchSourceRequest).first
            let trackSource = existingSource ?? TrackSource(context: context)
            trackSource.apply(from: sourceInfo)
            trackSource.track = track
        }
        
        return track
    }
}

// MARK: DailyRecord CoreData CRUD
extension CoreDataManager {
    // MARK: C (Upsert)
    func createDailyRecord(dailyRecord: AttDailyRecord) {
        createDailyRecord(dailyRecord: dailyRecord, source: dailyRecord.musicSource)
    }
    
    func createDailyRecord(dailyRecord: AttDailyRecord, source: MusicSource?) {
        let context = persistentContainer.viewContext
        
        // 0) 동일 날짜 존재 여부 확인
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        fetchRequest.fetchLimit = 10
        fetchRequest.predicate = NSPredicate(format: "date == %@", dailyRecord.date as CVarArg)
        
        do {
            let matches = try context.fetch(fetchRequest)
            
            // A) 이미 있으면 → 업데이트(여러 개가 있다면 모두 갱신)
            if !matches.isEmpty {
                matches.forEach { $0.update(as: dailyRecord) }
                
                // 음악 연결(옵셔널). 여기서만 source를 명시적으로 넘기면 TrackSource를 업서트함.
                if let info = dailyRecord.music {
                    let track = upsertTrackAndSource(music: info, source: source, in: context)
                    matches.forEach { track.addToDailyRecords($0) }
                }
                
                saveContext()
                return
            }
        } catch {
            print("Core Data fetch error: \(error.localizedDescription)")
        }
        
        // B) 없으면 → 신규 생성
        guard let daily = NSEntityDescription
            .insertNewObject(forEntityName: "DailyRecord", into: context) as? DailyRecord else { return }
        
        // 가능하면 프로퍼티 할당 사용 (래퍼가 있다면 래퍼로)
        daily.setValue(dailyRecord.date, forKey: "date")
        daily.setValue(UUID(), forKey: "id")
        daily.setValue(dailyRecord.mood?.rawValue, forKey: "mood")
        daily.setValue(dailyRecord.diary, forKey: "diary")
        daily.setValue(dailyRecord.phraseToTomorrow, forKey: "phraseToTomorrow")
        
        if let info = dailyRecord.music {
            let track = upsertTrackAndSource(music: info, source: source, in: context)
            track.addToDailyRecords(daily) // 또는 daily.track = track
        }
        saveContext()
    }
    
    // MARK: R
    /// 읽기: TrackSource는 기본적으로 prefetch하지 않음 → 접근 전까지 fault
    func fetchDailyRecords(startDate: Date, endDate: Date) -> [AttDailyRecord]? {
        let context = persistentContainer.viewContext
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as NSDate, endDate as NSDate)
        
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        fetchRequest.predicate = predicate
        // 필요 시에만 prefetch 추가: fetchRequest.relationshipKeyPathsForPrefetching = ["track", "track.sources"]
        
        do {
            let filtered = try context.fetch(fetchRequest)
            
            return filtered.compactMap { $0.toDomain() }
        } catch {
            print("데이터를 가져올 때 오류 발생: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: U
    /// 기본 update: TrackSource는 건드리지 않음
    func updateDailyRecord(dailyRecord: AttDailyRecord) {
        updateDailyRecord(dailyRecord: dailyRecord, source: nil)
    }
    
    /// 필요할 때만 TrackSource까지 함께 업서트
    func updateDailyRecord(dailyRecord: AttDailyRecord, source: MusicSource?) {
        let context = persistentContainer.viewContext
        let targetDate = dailyRecord.date
        
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", targetDate as CVarArg)
        
        do {
            let objs = try context.fetch(fetchRequest)
            for obj in objs {
                obj.update(as: dailyRecord)
                if let info = dailyRecord.music {
                    let track = upsertTrackAndSource(music: info, source: source, in: context)
                    track.addToDailyRecords(obj) // 또는 obj.track = track
                }
            }
            saveContext()
        } catch {
            print("Core Data fetch error: \(error.localizedDescription)")
        }
    }
    
    // MARK: D
    func deleteDailyRecord(dailyRecord: AttDailyRecord) {
        let context = persistentContainer.viewContext
        let targetDate = dailyRecord.date
        
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", targetDate as CVarArg)
        
        do {
            let objs = try context.fetch(fetchRequest)
            for obj in objs { context.delete(obj) }
            saveContext()
        } catch {
            print("Core Data fetch error: \(error.localizedDescription)")
        }
    }
    
    func deleteDailyRecord(date: Date) {
        let context = persistentContainer.viewContext
        
        print(Date())
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }
        
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as NSDate, nextDay as NSDate
        )
        
        do {
            let objs = try context.fetch(fetchRequest)
            for obj in objs { context.delete(obj) }
            saveContext()
        } catch {
            print("Core Data fetch error: \(error.localizedDescription)")
        }
    }
    
    func isTrackExist(title: String?, artist: String?) -> Track? {
        let context = persistentContainer.viewContext
        guard let title = title, let artist = artist else { return nil }
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "(title == %@) AND (primaryArtistName == %@)", title, artist)
        return try? context.fetch(fetchRequest).first
    }
}

// MARK: TEST SET
extension CoreDataManager {
    func deleteAllDailyRecord() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        
        do {
            let objects = try context.fetch(fetchRequest)
            for obj in objects { context.delete(obj) }
            saveContext()
        } catch {
            print("Core Data fetch error: \(error.localizedDescription)")
        }
    }
    
    func fetchAllDailyRecords() -> [AttDailyRecord]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        
        do {
            let data = try context.fetch(fetchRequest)
            return data.compactMap { $0.toDomain() }
        } catch {
            print("데이터를 가져올 때 오류 발생: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchAllMusicRecords() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        
        do {
            _ = try context.fetch(fetchRequest)
        } catch {
            print("데이터를 가져올 때 오류 발생: \(error.localizedDescription)")
        }
    }
}
