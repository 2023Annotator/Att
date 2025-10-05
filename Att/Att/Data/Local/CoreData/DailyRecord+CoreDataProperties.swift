//
//  DailyRecord+CoreDataProperties.swift
//  Att
//
//  Created by 황정현 on 9/14/25.
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
    @NSManaged public var track: Track?

}

extension DailyRecord : Identifiable {

}
