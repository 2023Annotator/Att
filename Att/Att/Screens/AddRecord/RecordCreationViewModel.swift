//
//  RecordCreationViewModel.swift
//  Att
//
//  Created by 황정현 on 2023/09/19.
//

import Foundation

final class RecordCreationViewModel {
    @Published var dailyRecord: AttDailyRecord = AttDailyRecord(date: Date())
    
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
