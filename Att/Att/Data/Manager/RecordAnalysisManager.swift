//
//  RecordAnalysisManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/22.
//

import Foundation

final class RecordAnalysisManager {
    private var wordAnalysisManager: WordAnalysisManager?

    private var minimumNeedRecordValue: Int = 10
    private let musicCount = 3
    private let wordCount = 3
    
    init(wordAnalysisManager: WordAnalysisManager) {
        self.wordAnalysisManager = wordAnalysisManager
    }

    private func isAvailableToMakeMonthAnalysis(date: Date) -> Bool {
        guard let dailyRecordList = getDataList(date: date) else { return false }
        if dailyRecordList.count < minimumNeedRecordValue { return false }
        return true
    }
    
    func getMonthlyRecord(date: Date) -> AttMonthlyRecord? {
        if !isAvailableToMakeMonthAnalysis(date: date) { return nil }
        
        guard let dailyRecordList = getDataList(date: date) else { return nil }
        
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
    
    func getMonthlyMood(date: Date) -> Mood? {
        if !isAvailableToMakeMonthAnalysis(date: date) { return nil }
        guard let dailyRecordList = getDataList(date: date) else { return nil }
        let moodFrequencyList = getMoodFrequencyDictionary(dailyRecords: dailyRecordList)?.first
        return moodFrequencyList?.key
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
        guard let startTime = sortedRecordedTimeDictionary.first?.key else { return nil }
        if let startTime = Int(startTime) {
            let endTime = (startTime + 1) % 24
            return "\(startTime)시 - \(endTime)시"
        }
        return nil
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
        let recordedMusicList = dailyRecords.map { MusicInfo(title: $0.musicInfo?.title, artist: $0.musicInfo?.artist) }
        var tempDictionary: [String: Int] = [:]
        
        for music in recordedMusicList {
            let titleAndArtist = music.artistAndTitleStr()
            tempDictionary[titleAndArtist, default: 0] += 1
        }
        
        var mostPlayedMusicDictionary: [MusicInfo: Int] = [:]
        for temp in tempDictionary {
            guard let info = dailyRecords.filter({$0.musicInfo?.artistAndTitleStr() == temp.key}).first else { return nil }
            guard let musicInfo = info.musicInfo else { return nil }
            mostPlayedMusicDictionary[musicInfo] = temp.value
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
