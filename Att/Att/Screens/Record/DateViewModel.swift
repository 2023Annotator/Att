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
    @Published var selectedIdx: IndexPath = IndexPath(row: 0, section: 0)
    
    init() {
        today = Date()
        centeredIdx = IndexPath(row: 14, section: 0)
        
        selectedIdx = IndexPath(row: 14 + currentWeekdayIdx(), section: 0)
        currentCenteredDate = getInitialCurrentCenteredDate()
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
    
    func currentWeekdayIdx() -> Int {
        let weekdayArr: [String] = ["월", "화", "수", "목", "금", "토", "일"]
        return weekdayArr.firstIndex(of: today.weekday()) ?? 6
    }
    
    func getInitialCurrentCenteredDate() -> Date {
        var adjustmentValue: Int = 0
        let currentWeekdayIdx = currentWeekdayIdx()
        if currentWeekdayIdx < 3 {
            adjustmentValue += 3 - currentWeekdayIdx
        } else if currentWeekdayIdx > 3 {
            adjustmentValue -= currentWeekdayIdx - 3
        }
        
        let calendar = Calendar.current
        if let centeredDate = calendar.date(byAdding: .day, value: adjustmentValue, to: today) {
            
            print("\(centeredDate) eee")
            return centeredDate
        }
        return Date()
    }
    
    func getCurrentWeekDates() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        
        for idx in -17 ... 17 {
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
    
    func changeCurrentSelectedIdx(as idx: IndexPath) {
        selectedIdx = idx
    }
    
    func changeCurrentSelectedIdx(cardCollectionViewIndexPath: IndexPath) {
        let currentSelectedIdx = selectedIdx.row % 7
        if cardCollectionViewIndexPath.row > currentSelectedIdx {
            selectedIdx.row += cardCollectionViewIndexPath.row - currentSelectedIdx
        } else {
            selectedIdx.row -= currentSelectedIdx - cardCollectionViewIndexPath.row
        }
    }
    
    func updateDateInfo(as idx: IndexPath) {
        currentCenteredDate = weekDates[idx.row]
        weekDates = getCurrentWeekDates()
        currentVisibleDates = getCurrentVisibleWeekDates()
        selectedIdx = selectedIdx
    }
}
