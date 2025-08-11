//
//  CoreDataManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/15.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private var persistentContainer: NSPersistentCloudKitContainer!
    
    private init() {
        initializePersistentContainer()
    }
    
    private func initializePersistentContainer() {
        persistentContainer = NSPersistentCloudKitContainer(name: "Att")
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext () {
        persistentContainer.viewContext.performAndWait {
            if self.persistentContainer.viewContext.hasChanges {
                do {
                    try self.persistentContainer.viewContext.save()
                } catch {
                    let nserror = error as NSError
                    print("SAVE NON COMPLETE: \(nserror)")
                }
            }
        }
    }
}

// MARK: DailyRecord CoreData CRUD
extension CoreDataManager {
    // MARK: C
    func createDailyRecord(dailyRecord: AttDailyRecord) {
        let context = persistentContainer.viewContext
        guard let dailyRecordEntity = NSEntityDescription
            .insertNewObject(forEntityName: "DailyRecord", into: context) as? DailyRecord else { return }

        dailyRecordEntity.setValue(dailyRecord.date, forKey: "date")
        dailyRecordEntity.setValue(UUID(), forKey: "id")
        dailyRecordEntity.setValue(dailyRecord.mood?.rawValue, forKey: "mood")
        dailyRecordEntity.setValue(dailyRecord.diary, forKey: "diary")
        dailyRecordEntity.setValue(dailyRecord.phraseToTomorrow, forKey: "phraseToTomorrow")

        if let info = dailyRecord.musicInfo {
            // 1) id로 우선 탐색, 2) 없으면 title+artist로 폴백
            if let existed = findMusic(by: info, in: context) {
                existed.addToDailyRecord(dailyRecordEntity)
            } else if let music = NSEntityDescription
                        .insertNewObject(forEntityName: "Music", into: context) as? Music {
                music.apply(from: info)
                music.addToDailyRecord(dailyRecordEntity)
            }
        }
        saveContext()
    }
    
    // MARK: R
    func fetchDailyRecords(startDate: Date, endDate: Date) -> [AttDailyRecord]? {
        let context = persistentContainer.viewContext
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as NSDate, endDate as NSDate)
        
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let filteredData = try context.fetch(fetchRequest)
            let dailyRecords = filteredData.compactMap { $0.toDomain() }
            return dailyRecords
        } catch {
            print("데이터를 가져올 때 오류 발생: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: U
    func updateDailyRecord(dailyRecord: AttDailyRecord) {
        let context = persistentContainer.viewContext
        let targetDate = dailyRecord.date
        
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", targetDate as CVarArg)
        
        do {
            let matchingObjects = try context.fetch(fetchRequest)
            
            for object in matchingObjects {
                object.update(as: dailyRecord)
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
            let matchingObjects = try context.fetch(fetchRequest)
            
            for object in matchingObjects {
                context.delete(object)
            }
            
            saveContext()
        } catch {
            print("Core Data fetch error: \(error.localizedDescription)")
        }
    }
    
    func isMusicExist(title: String?, artist: String?) -> Music? {
        let context = persistentContainer.viewContext
        guard let title = title,
              let artist = artist else { return nil }
        let fetchRequest: NSFetchRequest<Music> = Music.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(title == %@) AND (artist == %@)", title, artist)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let musicEntity = results.first {
                return musicEntity
            }
        } catch {
            print("데이터 검색 또는 저장 오류: \(error.localizedDescription)")
        }
        return nil
    }
    
    // id 우선 조회 -> 없으면 title+artist로 폴백
    private func findMusic(by info: MusicInfo, in context: NSManagedObjectContext) -> Music? {
        if let foundByID = fetchMusic(byID: info.id, in: context) {
            return foundByID
        }
        return fetchMusic(title: info.title, artist: info.artist, in: context)
    }

    private func fetchMusic(byID id: String, in context: NSManagedObjectContext) -> Music? {
        let req: NSFetchRequest<Music> = Music.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "id == %@", id)
        return try? context.fetch(req).first
    }

    private func fetchMusic(title: String, artist: String, in context: NSManagedObjectContext) -> Music? {
        let req: NSFetchRequest<Music> = Music.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "title == %@ AND artist == %@", title, artist)
        return try? context.fetch(req).first
    }
}

// MARK: TEST SET
extension CoreDataManager {
    func deleteAllDailyRecord() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        
        do {
            let matchingObjects = try context.fetch(fetchRequest)
            
            for object in matchingObjects {
                context.delete(object)
            }
            
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
        let fetchRequest: NSFetchRequest<Music> = Music.fetchRequest()
        
        do {
            let data = try context.fetch(fetchRequest)
        } catch {
            print("데이터를 가져올 때 오류 발생: \(error.localizedDescription)")
        }
    }
}
