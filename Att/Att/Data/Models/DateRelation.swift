//
//  DateRelation.swift
//  Att
//
//  Created by 황정현 on 2023/09/16.
//

import Foundation

enum DateRelation {
    case today
    case past
    case future
    
    var relationText: String {
        switch self {
        case .today:
            return "오늘 기록을 추가해주세요!"
        case .past:
            return "기록을 남기지 않은 날입니다!"
        case .future:
            return "아직 다가오지 않은\n미래입니다!"
        }
    }
}
