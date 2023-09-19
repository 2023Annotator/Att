//
//  DailyRecord+CoreDataProperties.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//
//

import Foundation
import UIKit.UIImage
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
    @NSManaged public var musicTitle: String?
    @NSManaged public var musicArtist: String?
    @NSManaged public var musicThumbnail: Data?

}

extension DailyRecord: Identifiable {
    func mapToModel() -> AttDailyRecord? {
        guard let date = self.date,
              let moodRawValue = self.mood,
              let mood = Mood(rawValue: moodRawValue),
              let musicThumbnailData = self.musicThumbnail
        else { return nil }
        
        let model = AttDailyRecord(
            date: date,
            mood: mood,
            musicInfo: MusicInfo(title: self.musicTitle, artist: self.musicArtist, thumbnailImage: UIImage(data: musicThumbnailData)),
            diary: self.diary,
            phraseToTomorrow: self.phraseToTomorrow)
        
        return model
    }
    
    func update(as dailyRecord: AttDailyRecord) {
        let musicThumbnailData = dailyRecord.musicInfo?.thumbnailImage?.jpegData(compressionQuality: 0.0)
        
        self.date = dailyRecord.date
        self.diary = dailyRecord.diary
        self.mood = dailyRecord.mood?.rawValue
        self.musicTitle = dailyRecord.musicInfo?.title
        self.musicArtist = dailyRecord.musicInfo?.artist
        self.musicThumbnail = musicThumbnailData
        self.phraseToTomorrow = phraseToTomorrow
    }

}
