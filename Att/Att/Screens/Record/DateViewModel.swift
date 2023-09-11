//
//  DateViewModel.swift
//  Att
//
//  Created by 황정현 on 2023/09/06.
//

import Foundation

final class DateViewModel {
    
    var today: Date
    var centeredIdx: IndexPath = IndexPath(row: 0, section: 0)
    
    @Published var currentCenteredDate: Date = Date()
    @Published var weekDates: [Date] = []
    @Published var currentVisibleDates: [Date] = []
    @Published var dateSelectedIdx: IndexPath = IndexPath(row: 0, section: 0)
    @Published var selectedDate: DateComponents?
    @Published var isCalendarViewDismissed: Bool = false
    
    let totalDataCount: Int = 35
    
    init() {
        today = Date()
        
        centeredIdx = IndexPath(row: 17, section: 0)
        dateSelectedIdx = IndexPath(row: 14 + currentWeekdayIdx(date: today), section: 0)
        
        currentCenteredDate = getCurrentCenteredDate(from: today)
        weekDates = getCurrentWeekDates()
        currentVisibleDates = getCurrentVisibleWeekDates()
    }
    
    func lastDayOfMonth(year: Int, month: Int) -> Int? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1 // 월의 첫 날로 설정
        
        if let firstDayOfNextMonth = calendar.date(from: dateComponents),
           let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: firstDayOfNextMonth) {
            return calendar.component(.day, from: lastDayOfMonth)
        }
        return nil
    }
    
    func getTodayIdx() -> Int {
//        let weekdayArr: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let weekdayArr: [String] = ["월", "화", "수", "목", "금", "토", "일"]
        let todayStr = today.weekday()
        guard let weekdayIdx = weekdayArr.firstIndex(of: todayStr) else { return  6 }
        
        return weekdayIdx
    }
    
    func currentWeekdayIdx(date: Date) -> Int {
//        let weekdayArr: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let weekdayArr: [String] = ["월", "화", "수", "목", "금", "토", "일"]
        let currentDayStr = date.weekday()
        guard let weekdayIdx = weekdayArr.firstIndex(of: currentDayStr) else { return  6 }
        
        return weekdayIdx
    }
    
    func getCurrentCenteredDate(from date: Date) -> Date {
        var adjustmentValue: Int = 0
        let currentWeekdayIdx = currentWeekdayIdx(date: date)
        if currentWeekdayIdx < 3 {
            adjustmentValue += 3 - currentWeekdayIdx
        } else if currentWeekdayIdx > 3 {
            adjustmentValue -= currentWeekdayIdx - 3
        }
        
        let calendar = Calendar.current
        if let centeredDate = calendar.date(byAdding: .day, value: adjustmentValue, to: date) {
            return centeredDate
        }
        return Date()
    }
    
    func getCurrentWeekDates() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        
        let range = totalDataCount/2
        for idx in -range ... range {
            guard let date = calendar.date(byAdding: .day, value: idx, to: currentCenteredDate) else {
                return []
            }
            dates.append(date)
        }
        return dates
    }
    
    func getCurrentVisibleWeekDates() -> [Date] {
        var dates: [Date] = []
        
        for idx in centeredIdx.row - 3 ... centeredIdx.row + 3 {
            dates.append(weekDates[idx])
        }
        return dates
    }
    
    func changeCurrentSelectedDateIdx(as idx: IndexPath) {
        dateSelectedIdx = idx
        updateSelectedDate()
    }
    
    func changeCurrentSelectedDateIdx(cardCollectionViewIndexPath: IndexPath) {
        let currentSelectedIdx = dateSelectedIdx.row % 7
        if cardCollectionViewIndexPath.row > currentSelectedIdx {
            dateSelectedIdx.row += cardCollectionViewIndexPath.row - currentSelectedIdx
        } else {
            dateSelectedIdx.row -= currentSelectedIdx - cardCollectionViewIndexPath.row
        }
        
        updateSelectedDate()
    }
    
    func updateSelectedDate() {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: weekDates[dateSelectedIdx.row])
        selectedDate = dateComponents
    }
    
    func updateCenteredDate(as idx: IndexPath) {
        currentCenteredDate = weekDates[idx.row]
        updateDateInfo()
    }
    
    func updateCenteredDate(as date: Date) {
        currentCenteredDate = date
        updateDateInfo()
        dateSelectedIdx = dateSelectedIdx
    }
    
    func updateDateInfo() {
        weekDates = getCurrentWeekDates()
        currentVisibleDates = getCurrentVisibleWeekDates()
    }
    
    func changeSelectedDate(as date: DateComponents) {
        selectedDate = date
        changeSelectedDate()
    }
    
    func changeSelectedDate() {
        guard let selectedDate = selectedDate?.date else { return }
        guard let date = dateFromString(selectedDate.date()) else { return }
        let weekDates = weekDates.map { $0.date() }
        
        if let idx = weekDates.firstIndex(of: date.date()) {
            let centerIndexPath = IndexPath(row: 7  * (idx / 7) + 3, section: 0)
            updateCenteredDate(as: centerIndexPath)
            changeCurrentSelectedDateIdx(as: IndexPath(row: 14 + currentWeekdayIdx(date: date), section: 0))
        } else {
            let centeredDate = getCurrentCenteredDate(from: date)
            updateCenteredDate(as: centeredDate)
        }
    }
    
    func dismissCalendarView() {
        isCalendarViewDismissed = true
    }
    
    func dateFromString(_ dateString: String) -> Date? {
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
    
    // TEST LOG
    func printAllComponent() {
        print("====================================")
        print("S:\(weekDates[0].date()) E:\(weekDates[34].date())")
        print("CS:\(currentVisibleDates[0].date()) CE:\(currentVisibleDates[6].date())")
        print("CENTER: \(currentVisibleDates[3].date())")
        print("SEL IDX: \(dateSelectedIdx) DATE: \(selectedDate)")
    }
}
