//
//  DailyRecord+CoreDataProperties.swift
//  Att
//
//  Created by 황정현 on 2023/09/15.
//
//

import Foundation
import CoreData

extension DailyRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyRecord> {
        return NSFetchRequest<DailyRecord>(entityName: "DailyRecord")
    }

    @NSManaged public var date: Date?
    @NSManaged public var diary: String?
    @NSManaged public var id: UUID?
    @NSManaged public var mood: String?
    @NSManaged public var phraseToTomorrow: String?

}

extension DailyRecord: Identifiable {
    func mapToModel() -> DailyRecordModel? {
        guard let date = self.date,
              let moodRawValue = self.mood,
              let mood = Mood(rawValue: moodRawValue)
        else { return nil }
        
        let model = DailyRecordModel(
            date: date,
            mood: mood,
            diary: self.diary,
            phraseToTomorrow: self.phraseToTomorrow)
        
        return model
    }
    
    func update(as dailyRecord: DailyRecordModel) {
        self.date = dailyRecord.date
        self.diary = dailyRecord.diary
        self.mood = dailyRecord.mood.rawValue
        self.phraseToTomorrow = phraseToTomorrow
    }
}
