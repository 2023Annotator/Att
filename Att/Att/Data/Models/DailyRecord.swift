//
//  DailyRecord.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import Foundation
import UIKit.UIImage

struct AttDailyRecord: Hashable {
    
    static func == (lhs: AttDailyRecord, rhs: AttDailyRecord) -> Bool {
        return lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(date)
    }
    
    var date: Date
    var mood: Mood?
    var musicInfo: MusicInfo?
    var diary: String?
    var phraseToTomorrow: String?
}
