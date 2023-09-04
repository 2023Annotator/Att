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
}
