//
//  AnalysisViewModel.swift
//  Att
//
//  Created by 황정현 on 2023/09/23.
//

import Foundation

final class AnalysisViewModel {
    @Published var currentMonthlyRecord: AttMonthlyRecord?
    @Published var monthlyMoodRecords: [MonthlyMoodRecord?]?
    @Published var currentYear: Int = 0
    
    private var recordAnalysisManager: RecordAnalysisManager?
    
    init(manager: RecordAnalysisManager) {
        self.recordAnalysisManager = manager
        guard let year = Int(Date().year()) else { return }
        self.currentYear = year
        updateYearlyMonthRecords()
    }
    
    func getMoodList() -> [Mood?]? {
        return currentMonthlyRecord?.moodList
    }
    
    func isMonthlyRecordAccessible(indexPath: IndexPath) -> Bool {
        return monthlyMoodRecords?[indexPath.row]?.mood != nil
    }
    
    func updateMonthlyRecord(month: Int) {
        guard let date = firstDayOfMonth(year: currentYear, month: month) else { return }
        guard let monthlyRecord = recordAnalysisManager?.getMonthlyRecord(date: date) else { return }
        currentMonthlyRecord = monthlyRecord
    }
    
    func updateYearlyMonthRecords() {
        let maximumRange = currentYear == Int(Date().year()) ? Date().previousMonth() : 12
        guard let maximumRange = maximumRange else { return }
        let months = Range<Int>(1...maximumRange)
        var moodRecords: [MonthlyMoodRecord?] = []
        
        for month in months {
            let monthName = monthName(for: month)
            guard let date = firstDayOfMonth(year: currentYear, month: month) else { return }
            let moodRecord = recordAnalysisManager?.getMonthlyMood(date: date)
            moodRecords.append(MonthlyMoodRecord(month: monthName, mood: moodRecord))
        }
        monthlyMoodRecords = moodRecords
    }
    
    func increaseYear() {
        currentYear += 1
        updateYearlyMonthRecords()
    }
    
    func decreaseYear() {
        currentYear -= 1
        updateYearlyMonthRecords()
    }
}

extension AnalysisViewModel {
    private func firstDayOfMonth(year: Int, month: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        
        let calendar = Calendar(identifier: .gregorian)
        if let firstDateOfMonth = calendar.date(from: dateComponents) {
            return firstDateOfMonth
        }
        
        return nil
    }
    
    private func monthName(for monthNumber: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        
        if let monthDate = Calendar.current.date(from: DateComponents(year: 2000, month: monthNumber, day: 1)) {
            let monthName = dateFormatter.monthSymbols[Calendar.current.component(.month, from: monthDate) - 1]
            return monthName
        }
        
        return nil
    }
}
