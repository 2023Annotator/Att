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
}
