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
        guard let entity = NSEntityDescription.entity(forEntityName: "DailyRecord", in: context) else { return }
        
        let record = NSManagedObject(entity: entity, insertInto: context)
        record.setValue(dailyRecord.date, forKey: "date")
        record.setValue(UUID(), forKey: "id")
        record.setValue(dailyRecord.mood?.rawValue, forKey: "mood")
        record.setValue(dailyRecord.diary, forKey: "diary")
        record.setValue(dailyRecord.phraseToTomorrow, forKey: "phraseToTomorrow")
        
        saveContext()
    }
    
    // MARK: R
    func fetchDailyRecords(startDate: Date, endDate: Date) -> [AttDailyRecord]? {
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as NSDate, endDate as NSDate)
        
        let fetchRequest: NSFetchRequest<DailyRecord> = DailyRecord.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let filteredData = try context.fetch(fetchRequest)
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
}

// MARK: TEST SET
extension CoreDataManager {
    func deleteAllDailyRecord() {
        print("일단은 전체 데이터 제거")
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
            // 필터링된 데이터를 가져옵니다.
            let data = try context.fetch(fetchRequest)
            return data.compactMap { $0.mapToModel() }
        } catch {
            print("데이터를 가져올 때 오류 발생: \(error.localizedDescription)")
            return nil
        }
    }
    
//    func createDummyData() {
//        let dataList = DummyCoreDataManager.shared.getDummyDailyDataList()
//        for data in dataList {
//            CoreDataManager.shared.createDailyRecord(dailyRecord: data)
//        }
//    }
}