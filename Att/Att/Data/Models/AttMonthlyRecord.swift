//
//  AttMonthlyRecord.swift
//  Att
//
//  Created by 황정현 on 2023/09/23.
//

import Foundation

struct AttMonthlyRecord {
    var yearAndMonth: String?
    var averageRecordTime: String?
    var moodList: [Mood?]?
    var moodFrequencyDictionary: [Mood: Int]?
    var mostPlayedMusicInfoDictionary: [MusicInfo: Int]?
    var mostUsedWordDictionary: [String: Int]?
}
