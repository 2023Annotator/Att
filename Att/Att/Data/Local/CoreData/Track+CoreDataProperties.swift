//
//  Track+CoreDataProperties.swift
//  Att
//
//  Created by 황정현 on 9/14/25.
//
//

import Foundation
import CoreData

extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var artworkURL: String?
    @NSManaged public var durationMs: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var isrc: String?
    @NSManaged public var previewURL: String?
    @NSManaged public var primaryArtistName: String?
    @NSManaged public var title: String?
    @NSManaged public var dailyRecords: NSSet?
    @NSManaged public var sources: NSSet?

}

// MARK: Generated accessors for dailyRecords
extension Track {

    @objc(addDailyRecordsObject:)
    @NSManaged public func addToDailyRecords(_ value: DailyRecord)

    @objc(removeDailyRecordsObject:)
    @NSManaged public func removeFromDailyRecords(_ value: DailyRecord)

    @objc(addDailyRecords:)
    @NSManaged public func addToDailyRecords(_ values: NSSet)

    @objc(removeDailyRecords:)
    @NSManaged public func removeFromDailyRecords(_ values: NSSet)

}

// MARK: Generated accessors for sources
extension Track {

    @objc(addSourcesObject:)
    @NSManaged public func addToSources(_ value: TrackSource)

    @objc(removeSourcesObject:)
    @NSManaged public func removeFromSources(_ value: TrackSource)

    @objc(addSources:)
    @NSManaged public func addToSources(_ values: NSSet)

    @objc(removeSources:)
    @NSManaged public func removeFromSources(_ values: NSSet)

}

extension Track : Identifiable {

}
