//
//  TrackSource+CoreDataProperties.swift
//  Att
//
//  Created by 황정현 on 9/14/25.
//
//

import Foundation
import CoreData

extension TrackSource {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackSource> {
        return NSFetchRequest<TrackSource>(entityName: "TrackSource")
    }

    @NSManaged public var artworkURLTemplate: String?
    @NSManaged public var deeplinkURI: URL?
    @NSManaged public var id: UUID?
    @NSManaged public var isrc: String?
    @NSManaged public var previewURL: String?
    @NSManaged public var storefront: String?
    @NSManaged public var vendor: String?
    @NSManaged public var vendorTrackId: String?
    @NSManaged public var track: Track?

}

extension TrackSource : Identifiable {

}
