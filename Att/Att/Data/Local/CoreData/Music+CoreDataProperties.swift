//
//  Music+CoreDataProperties.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//
//

import Foundation
import CoreData

extension Music {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Music> {
        return NSFetchRequest<Music>(entityName: "Music")
    }

    @NSManaged public var artist: String?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var artworkURL: String?
    @NSManaged public var previewURL: String?
    @NSManaged public var dailyRecord: NSSet?

}

// MARK: Generated accessors for dailyRecord
extension Music {

    @objc(addDailyRecordObject:)
    @NSManaged public func addToDailyRecord(_ value: DailyRecord)

    @objc(removeDailyRecordObject:)
    @NSManaged public func removeFromDailyRecord(_ value: DailyRecord)

    @objc(addDailyRecord:)
    @NSManaged public func addToDailyRecord(_ values: NSSet)

    @objc(removeDailyRecord:)
    @NSManaged public func removeFromDailyRecord(_ values: NSSet)
}

// MARK: - Music ↔ MusicInfo
extension Music {
    func toDomain() -> MusicInfo? {
        guard let id, let title, let artist else { return nil }
        return MusicInfo(
            id: id,
            title: title,
            artist: artist,
            artworkURL: artworkURL.flatMap(URL.init(string:)),
            previewURL: previewURL.flatMap(URL.init(string:))
        )
    }

    func apply(from info: MusicInfo) {
        self.id = info.id
        self.title = info.title
        self.artist = info.artist
        self.artworkURL = info.artworkURL?.absoluteString
        self.previewURL = info.previewURL?.absoluteString
    }
}
