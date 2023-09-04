//
//  CardInfoType.swift
//  Att
//
//  Created by 황정현 on 2023/08/04.
//

import Foundation

enum CardInfoType {
    case diary
    case music
    case fromYesterday
    
    var name: String {
        switch self {
        case .diary:
            return "Diary"
        case .music:
            return "Now Playing"
        case .fromYesterday:
            return "From. Yesterday"
        }
    }
}
