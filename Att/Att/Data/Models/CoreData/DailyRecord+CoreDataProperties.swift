//
//  DailyRecord+CoreDataProperties.swift
//  Att
//
//  Created by 황정현 on 2023/09/24.
//
//

import Foundation
import CoreData
import UIKit.UIImage


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

extension DailyRecord : Identifiable {
    func mapToModel() -> AttDailyRecord? {
        guard let date = self.date,
              let moodRawValue = self.mood,
              let mood = Mood(rawValue: moodRawValue),
              let music = music
        else { return nil }
        
        guard let musicThumbnailData = music.thumbnail else { return nil }
        
        let model = AttDailyRecord(
            date: date,
            mood: mood,
            musicInfo: MusicInfo(title: music.title, artist: music.artist, thumbnailImage: UIImage(data: musicThumbnailData)),
            diary: self.diary,
            phraseToTomorrow: self.phraseToTomorrow)
        
        return model
    }
    
    func update(as dailyRecord: AttDailyRecord) {
        let musicThumbnailData = dailyRecord.musicInfo?.thumbnailImage?.jpegData(compressionQuality: 0.0)
        
        self.date = dailyRecord.date
        self.diary = dailyRecord.diary
        self.mood = dailyRecord.mood?.rawValue
        self.phraseToTomorrow = phraseToTomorrow
        
        self.music?.title = dailyRecord.musicInfo?.title
        self.music?.artist = dailyRecord.musicInfo?.artist
        self.music?.thumbnail = musicThumbnailData
    }

}
