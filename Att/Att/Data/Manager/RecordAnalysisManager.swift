//
//  RecordAnalysisManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/22.
//

import Foundation

final class RecordAnalysisManager {
    var wordAnalysisManager: WordAnalysisManager?
    var dailyRecordList: [AttDailyRecord]?
    var monthlyRecord: AttMonthlyRecord?
    
    var minimumNeedRecordValue: Int = 10
    
    let musicCount = 3
    let wordCount = 3
    
    init(date: Date, wordAnalysisManager: WordAnalysisManager) {
        self.wordAnalysisManager = wordAnalysisManager
        
        if !isAvailableToMakeMonthAnalysis(date: date) { return }
        
        guard let dailyRecordList = getDataList(date: date) else { return }
        monthlyRecord = getMonthlyRecord(dailyRecordList: dailyRecordList)
    }
    
    // 조건 1. 한 달이 종료되었는지
    // 조건 2. 기록이 이미 쌓였는지 -> 쌓인 경우 break
    // 조건 3. 최소 기록 필요 수를 넘겼는지
    private func isAvailableToMakeMonthAnalysis(date: Date) -> Bool {
        guard let dailyRecordList = getDataList(date: date) else { return false }
        if dailyRecordList.count < minimumNeedRecordValue { return false }
        return true
    }
    
    private func getMonthlyRecord(dailyRecordList: [AttDailyRecord]) -> AttMonthlyRecord? {
        
        wordAnalysisManager?.tokenizeText(getDiaryTexts(dailyRecords: dailyRecordList))
        let yearAndMonth = getYearAndMonth(dailyRecords: dailyRecordList)
        let averageRecordTime = getAverageRecordTime(dailyRecords: dailyRecordList)
        let moodList = getMoodList(dailyRecords: dailyRecordList)
        let moodFrequencyList = getMoodFrequencyDictionary(dailyRecords: dailyRecordList)
        let mostPlayedMusicInfo = getMostPlayedMusicDictionary(dailyRecords: dailyRecordList)
        let mostUsedWordDictionary = wordAnalysisManager?.getMostUsedWordDicionry()
        
        let monthlyRecord = AttMonthlyRecord(yearAndMonth: yearAndMonth,
                                              averageRecordTime: averageRecordTime,
                                              moodList: moodList,
                                              moodFrequencyDictionary: moodFrequencyList,
                                              mostPlayedMusicInfoDictionary: mostPlayedMusicInfo,
                                             mostUsedWordDictionary: mostUsedWordDictionary)
        
        return monthlyRecord
    }
    
    private func getDataList(date: Date) -> [AttDailyRecord]? {
        guard let startDate = date.startOfMonth() else { return nil }
        guard let endDate = date.endOfMonth() else { return nil }
        let dailyRecords = CoreDataManager.shared.fetchDailyRecords(startDate: startDate, endDate: endDate)
        return dailyRecords
    }
    
    private func getYearAndMonth(dailyRecords: [AttDailyRecord]) -> String? {
        guard let dailyRecordsFirstDate = dailyRecords.first?.date else { return nil }
        let yearAndMonth = dailyRecordsFirstDate.yearAndMonth()
        return yearAndMonth
    }
    
    private func getAverageRecordTime(dailyRecords: [AttDailyRecord]) -> String? {
        let recordedTimeList = dailyRecords.map { $0.date.hour() }
        var recordedTimeDictionary: [String: Int] = [:]
        for recordedTime in recordedTimeList {
            if let recordedTimeCount = recordedTimeDictionary[recordedTime] {
                recordedTimeDictionary.updateValue(recordedTimeCount + 1, forKey: recordedTime)
            } else {
                recordedTimeDictionary[recordedTime] = 1
            }
        }
        
        let sortedRecordedTimeDictionary = recordedTimeDictionary.sorted(by: {$0.value > $1.value})
        return sortedRecordedTimeDictionary.first?.key
    }
    
    private func getMoodList(dailyRecords: [AttDailyRecord]) -> [Mood?] {
        let moodList = dailyRecords.map { $0.mood }
        return moodList
    }
    
    private func getMoodFrequencyDictionary(dailyRecords: [AttDailyRecord]) -> [Mood: Int]? {
        var moodFrequencyDictionary: [Mood: Int] = [:]
        let moodList = dailyRecords.map { $0.mood }
        for idx in 0..<moodList.count {
            guard let mood = moodList[idx] else { continue }
            if let moodCount = moodFrequencyDictionary[mood] {
                moodFrequencyDictionary.updateValue(moodCount + 1, forKey: mood)
            } else {
                moodFrequencyDictionary[mood] = 1
            }
        }
        
        let dictionary = Array(moodFrequencyDictionary.prefix(5))
        
        return Dictionary(uniqueKeysWithValues: dictionary)
    }
    
    private func getMostPlayedMusicDictionary(dailyRecords: [AttDailyRecord]) -> [MusicInfo: Int]? {
        let recordedMusicList = dailyRecords.map { $0.musicInfo }
        var mostPlayedMusicDictionary: [MusicInfo: Int] = [:]
        for recordedMusic in recordedMusicList {
            guard let recordedMusic = recordedMusic else { continue }
            if let recordedTimeCount = mostPlayedMusicDictionary[recordedMusic] {
                mostPlayedMusicDictionary.updateValue(recordedTimeCount + 1, forKey: recordedMusic)
            } else {
                mostPlayedMusicDictionary[recordedMusic] = 1
            }
        }
        
        let sortedMusicDictionary = mostPlayedMusicDictionary
            .sorted(by: {$0.value > $1.value})
        let dictionary = Array(sortedMusicDictionary.prefix(3))
        
        return Dictionary(uniqueKeysWithValues: dictionary)
    }
    
    private func getDiaryTexts(dailyRecords: [AttDailyRecord]) -> [String?] {
        return dailyRecords.map { $0.diary }
    }

}
