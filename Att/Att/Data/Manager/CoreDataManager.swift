//
//  CoreDataManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/15.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Att")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
    
    private init() { }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: DailyRecord CoreData CRUD
extension CoreDataManager {
    // MARK: C
    func createDailyRecord(dailyRecord: AttDailyRecord) {
        guard let dailyRecordEntity = NSEntityDescription.insertNewObject(forEntityName: "DailyRecord", into: context) as? DailyRecord else { return }
        guard let musicThumbnailData = dailyRecord.musicInfo?.thumbnailImage?.jpegData(compressionQuality: 0.0) else { return }
        
        dailyRecordEntity.setValue(dailyRecord.date, forKey: "date")
        dailyRecordEntity.setValue(UUID(), forKey: "id")
        dailyRecordEntity.setValue(dailyRecord.mood?.rawValue, forKey: "mood")
        dailyRecordEntity.setValue(dailyRecord.diary, forKey: "diary")
        dailyRecordEntity.setValue(dailyRecord.phraseToTomorrow, forKey: "phraseToTomorrow")
        
        if let existedMusicEntity = isMusicExist(title: dailyRecord.musicInfo?.title, artist: dailyRecord.musicInfo?.artist) {
            existedMusicEntity.addToDailyRecord(dailyRecordEntity)
        } else {
            guard let musicEntity = NSEntityDescription.insertNewObject(forEntityName: "Music", into: context) as? Music else { return }
            musicEntity.setValue(dailyRecord.musicInfo?.title, forKey: "title")
            musicEntity.setValue(dailyRecord.musicInfo?.artist, forKey: "artist")
            musicEntity.setValue(musicThumbnailData, forKey: "thumbnail")
            
            musicEntity.addToDailyRecord(dailyRecordEntity)
        }
        
        saveContext()
    }
    
    // MARK: R
    func fetchDailyRecords(startDate: Date, endDate: Date) -> [AttDailyRecord]? {
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as NSDate, endDate as NSDate)
        
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let filteredData = try context.fetch(fetchRequest)
            let dailyRecord = filteredData.compactMap { $0.mapToModel() }
            
            return filteredData.compactMap { $0.mapToModel() }
        } catch {
            print("데이터를 가져올 때 오류 발생: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: U
    func updateDailyRecord(dailyRecord: AttDailyRecord) {
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
}

// MARK: TEST SET
extension CoreDataManager {
    func deleteAllDailyRecord() {
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
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        
        do {
            let data = try context.fetch(fetchRequest)
            return data.compactMap { $0.mapToModel() }
        } catch {
            print("데이터를 가져올 때 오류 발생: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchAllMusicRecords() {
        let fetchRequest: NSFetchRequest<Music> = Music.fetchRequest()
        
        do {
            let data = try context.fetch(fetchRequest)
            print(data)
        } catch {
            print("데이터를 가져올 때 오류 발생: \(error.localizedDescription)")
        }
    }
}
