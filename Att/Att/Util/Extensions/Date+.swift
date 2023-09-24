//
//  Date+.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import Foundation

extension Date {
    func date() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    func year() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    func month() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    func previousMonth() -> Int? {
        if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self) {
            return Int(previousMonth.month())
        }
        return nil
    }
    
    func yearAndMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM"
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    func monthAndDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd"
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    func day() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    func weekday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    func hour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let convertedDate = dateFormatter.string(from: self)
        return convertedDate
    }
    
    func publicationDate() -> String {
        var convertedDate: String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        convertedDate.append(dateFormatter.string(from: self))
        
        let userTimeZone = TimeZone(abbreviation: "KST")
        guard let timeZone = userTimeZone else { return "" }
        convertedDate.append(" \(timeZone.identifier) ")
        
        dateFormatter.dateFormat = "HH:mm"
        convertedDate.append(dateFormatter.string(from: self))
        
        return "발행 시간:\(convertedDate)"
    }
    
    func currentKoreanDate() -> Date {
        let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")!
        return Date().inTimeZone(koreanTimeZone)
    }
    
    func inTimeZone(_ timeZone: TimeZone) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from: self)
        return dateFormatter.date(from: dateString)!
    }
    
    func relativeDate() -> DateRelation {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selfDate = calendar.startOfDay(for: self)
        
        if selfDate == today {
            return .today
        } else if selfDate < today {
            return .past
        } else {
            return .future
        }
    }
    
    func isFirstDayOfTheMonthPassed() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let convertedDateStr = dateFormatter.string(from: self)
        guard let convertedDateInt = Int(convertedDateStr) else { return  false }
        if convertedDateInt >= 1 {
            return true
        } else {
            return false
        }
    }
    
    func startOfMonth() -> Date? {
        
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        
        let startComponents = DateComponents(year: year, month: month, day: 1)
        guard let startDate = calendar.date(from: startComponents) else {
            return nil
        }
        
        return startDate
    }
    
    func endOfMonth() -> Date? {
        let calendar = Calendar.current
        
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: self)
        let endComponents = calendar.dateComponents([.year, .month], from: nextMonth!)
        let endDate = calendar.date(from: endComponents)?.addingTimeInterval(-1)
        
        return endDate
    }

}
        
