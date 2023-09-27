//
//  Music+CoreDataProperties.swift
//  Att
//
//  Created by 황정현 on 2023/09/24.
//
//

import Foundation
import CoreData


extension Music {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Music> {
        return NSFetchRequest<Music>(entityName: "Music")
    }

    @NSManaged public var title: String?
    @NSManaged public var artist: String?
    @NSManaged public var thumbnail: Data?
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

extension Music: Identifiable {

}
