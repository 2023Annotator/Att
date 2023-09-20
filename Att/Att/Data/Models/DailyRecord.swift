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
    
    let date: Date
    let mood: Mood?
    let musicInfo: MusicInfo?
    let diary: String?
    let phraseToTomorrow: String?
}
