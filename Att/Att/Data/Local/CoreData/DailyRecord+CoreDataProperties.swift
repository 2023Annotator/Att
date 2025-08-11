//
//  DailyRecord+CoreDataProperties.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
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
    @NSManaged public var music: Music?

}

extension DailyRecord: Identifiable {
    func toDomain() -> AttDailyRecord? {
        guard
            let date,
            let moodRaw = mood,
            let mood = Mood(rawValue: moodRaw)
        else { return nil }

        // music은 선택값으로 처리
        let mappedMusic = music?.toDomain()

        return AttDailyRecord(
            date: date,
            mood: mood,
            musicInfo: mappedMusic,
            diary: diary,
            phraseToTomorrow: phraseToTomorrow
        )
    }

    func update(as dailyRecord: AttDailyRecord) {
        self.date = dailyRecord.date
        self.diary = dailyRecord.diary
        self.mood = dailyRecord.mood?.rawValue
        self.phraseToTomorrow = dailyRecord.phraseToTomorrow  // ← 버그 수정

        if let info = dailyRecord.musicInfo {
            // 기존 관계가 있으면 갱신, 없으면 생성
            if let music = self.music {
                music.apply(from: info)
            } else {
                let music = Music(context: managedObjectContext!)
                music.apply(from: info)
                self.music = music
            }
        } else {
            self.music = nil
        }
    }
}
