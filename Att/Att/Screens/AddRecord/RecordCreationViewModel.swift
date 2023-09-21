//
//  RecordCreationViewModel.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import Foundation

final class RecordCreationViewModel {
    @Published var phraseFromYesterday: String?
    @Published var dailyRecord: AttDailyRecord = AttDailyRecord(date: Date())
    
    init(phraseFromYesterday: String?) {
        self.phraseFromYesterday = phraseFromYesterday
    }
    func setMusicInfo(musicInfo: MusicInfo?) {
        dailyRecord.musicInfo = musicInfo
    }
    
    func setDiary(as text: String?) {
        dailyRecord.diary = text
    }
    
    func setPraseToTomorrow(as text: String?) {
        dailyRecord.phraseToTomorrow = text
    }
}
