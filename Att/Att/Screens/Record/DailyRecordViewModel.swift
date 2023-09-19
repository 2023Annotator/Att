//
//  DateViewModel.swift
//  Att
//
//  Created by 황정현 on 2023/09/06.
//

import Foundation

final class DailyRecordViewModel {
    
    var today: Date
    
    @Published var weekDates: [Date] = []
    @Published var visibleDates: [Date] = []
    
    @Published var centeredDate: Date = Date()
    @Published var selectedDateIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    @Published var selectedCardIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    @Published var selectedDateComponents: DateComponents?
    
    @Published var isCalendarViewDismissed: Bool = false
    
    let weekday = 7
    let totalDataCount: Int = 35
    
    @Published var dailyRecordList: [AttDailyRecord?] = []
    @Published var phraseFromYesterdayList: [String?] = []
    @Published var currentPhraseFromYesterday: String?
    @Published var currentDailyRecord: AttDailyRecord?
    
    init() {
        today = Date().currentKoreanDate()
        selectedDateIndexPath = IndexPath(row: weekday * 2 + weekdayIndex(date: today), section: 0)
        
        centeredDate = getCurrentCenteredDate(from: today)
        
        updateDates()
    }

    private func weekdayIndex(date: Date) -> Int {
//        let weekdayArr: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let weekdayArr: [String] = ["월", "화", "수", "목", "금", "토", "일"]
        let currentDayStr = date.weekday()
        guard let weekdayIdx = weekdayArr.firstIndex(of: currentDayStr) else { return  6 }
        
        return weekdayIdx
    }
    
    private func getCurrentCenteredDate(from date: Date) -> Date {
        var adjustmentValue: Int = 0
        let currentWeekdayIdx = weekdayIndex(date: date)
        if currentWeekdayIdx < 3 {
            adjustmentValue += 3 - currentWeekdayIdx
        } else if currentWeekdayIdx > 3 {
            adjustmentValue -= currentWeekdayIdx - 3
        }
        
        let calendar = Calendar.current
        if let centeredDate = calendar.date(byAdding: .day, value: adjustmentValue, to: date) {
            return calendar.startOfDay(for: centeredDate)
        }
        return Date()
    }
    
    private func getCurrentWeekDates() -> [Date] {
        var dates: [Date] = []
        guard let timeZone = TimeZone(identifier: "Asia/Seoul") else { return [] }
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let range = totalDataCount/2
        for idx in -range ... range {
            guard let date = calendar.date(byAdding: .day, value: idx, to: centeredDate) else {
                return []
            }
            dates.append(date)
        }
        return dates
    }
    
    private func getCurrentVisibleWeekDates() -> [Date] {
        var dates: [Date] = []
        
        for idx in centeredRange() {
            dates.append(weekDates[idx])
        }
        return dates
    }
    
    private func updateSelectedDateComponents() {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: weekDates[selectedDateIndexPath.row])
        selectedDateComponents = dateComponents
    }
    
    private func updateCenteredDate(as date: Date) {
        centeredDate = date
    }
    
    private func updateDates() {
        weekDates = getCurrentWeekDates()
        visibleDates = getCurrentVisibleWeekDates()
        
        updateRecords()
        updateSelectedDateRecord()
    }
    
    private func updateCenteredDateWithSelectedDate(date: Date) {
        let weekDates = weekDates.map { $0.date() }
        if let idx = weekDates.firstIndex(of: date.date()) {
            let centerIndexPath = IndexPath(row: weekday  * (idx / weekday) + 3, section: 0)
            updateCenteredDateWithIndexPath(as: centerIndexPath)
        } else {
            let centeredDate = getCurrentCenteredDate(from: date)
            updateCenteredDate(as: centeredDate)
            updateDates()
        }
    }
}

// MARK: internal Methods
extension DailyRecordViewModel {
    func updateCurrentSelectedDateIndexPath(as indexPath: IndexPath) {
        selectedDateIndexPath = indexPath
    }
    
    func updateCurrentSelectedDateIndexPath(cardCollectionViewIndexPath: IndexPath) {
        let currentSelectedIdx = selectedDateIndexPath.row % weekday
        if cardCollectionViewIndexPath.row > currentSelectedIdx {
            selectedDateIndexPath.row += cardCollectionViewIndexPath.row - currentSelectedIdx
        } else {
            selectedDateIndexPath.row -= currentSelectedIdx - cardCollectionViewIndexPath.row
        }
        
        updateSelectedDateComponents()
        updateSelectedDateRecord()
    }
    
    func updateSelectedCardIndexPath(as indexPath: IndexPath) {
        selectedCardIndexPath = indexPath
    }
    
    func updateCenteredDateWithIndexPath(as indexPath: IndexPath) {
        centeredDate = weekDates[indexPath.row]
        updateDates()
    }
    
    func changeSelectedDateComponents(as date: DateComponents) {
        selectedDateComponents = date
        guard let selectedDateComponents = selectedDateComponents else { return }
        let selectedDate = dateComponentsToDate(dateComponents: selectedDateComponents)
        updateCenteredDateWithSelectedDate(date: selectedDate)
        updateCurrentSelectedDateIndexPath(as: IndexPath(row: 14 + weekdayIndex(date: selectedDate), section: 0))
    }
    
    func dismissCalendarView() {
        isCalendarViewDismissed = true
    }
}
extension DailyRecordViewModel {
    private func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")

        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return nil
        }
    }
    
    private func dateComponentsToDate(dateComponents: DateComponents) -> Date {
        guard let selectedDate = selectedDateComponents?.date else { return Date() }
        guard let date = dateFromString(selectedDate.date()) else { return Date() }
        return date
    }
    
    private func centeredRange() -> ClosedRange<Int> {
        let centeredIdx = totalDataCount / 2
        let deltaValue = weekday / 2
        return centeredIdx - deltaValue...centeredIdx + deltaValue
    }
    
    private func updateRecords() {
        
        guard let startDate = Calendar.current.date(byAdding: .day, value: -4, to: centeredDate) else { return }
        guard let endDate = Calendar.current.date(byAdding: .day, value: 4, to: centeredDate) else { return }

        guard let dailyRecordList = CoreDataManager.shared.fetchDailyRecords(startDate: startDate, endDate: endDate) else { return }
        
        updateDailyRecordList(dailyRecordList: dailyRecordList)
        updatePhraseFromYesterdayList(dailyRecordList: dailyRecordList)
    }
    
    private func updateDailyRecordList(dailyRecordList: [AttDailyRecord]) {
            var tempDailyRecordList: [AttDailyRecord?] = []
            
            for idx in centeredRange() {
                let date = weekDates[idx].date()
                let data = dailyRecordList.filter({$0.date.date() == date})
                if data.count == 0 {
                    let temp = AttDailyRecord(date: weekDates[idx], mood: nil, musicInfo: nil, diary: nil, phraseToTomorrow: nil)
                    tempDailyRecordList.append(temp)
                } else {
                    tempDailyRecordList.append(data.first)
                }
            }
            self.dailyRecordList = tempDailyRecordList
    }
    
    private func updatePhraseFromYesterdayList(dailyRecordList: [AttDailyRecord]) {
        var tempPhraseFromYesterdayList: [String?] = []
        
        for idx in centeredRange() {
            let yesterdayIndex = idx - 1
            let date = weekDates[yesterdayIndex].date()
            let data = dailyRecordList.filter({$0.date.date() == date})
            if data.count == 0 {
                tempPhraseFromYesterdayList.append(nil)
            } else {
                tempPhraseFromYesterdayList.append(data.first?.phraseToTomorrow)
            }
        }
        phraseFromYesterdayList = tempPhraseFromYesterdayList
    }
    
    private func updateSelectedDateRecord() {
        currentDailyRecord = dailyRecordList[selectedDateIndexPath.row % weekday]
        currentPhraseFromYesterday = phraseFromYesterdayList[selectedDateIndexPath.row % weekday]
    }
}

// MARK: TEST
extension DailyRecordViewModel {
    // TEST & DUMMY
    func printAllComponent() {
        print("====================================")
        print("S:\(weekDates[0].date()) E:\(weekDates[34].date())")
        print("CS:\(visibleDates[0].date()) CE:\(visibleDates[6].date())")
        print("CENTER: \(visibleDates[3].date())")
        print("SEL IDX: \(selectedDateIndexPath) DATE: \(String(describing: selectedDateComponents))")
    }
    
}
