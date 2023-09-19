//
//  Mood.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import Foundation
import UIKit.UIColor

enum Mood: String, Codable {
    case joy = "Joy"
    case sadness = "Sadness"
    case anger = "Anger"
    case calm = "Calm"
    case surprise = "Surprise"
    case fear = "Fear"
    
    var moodColor: UIColor {
        switch self {
        case .joy:
            return .yellow
        case .sadness:
            return .blue
        case .anger:
            return .cherry
        case .calm:
            return .yellowGreen
        case .surprise:
            return .pink
        case .fear:
            return .purple
        }
    }
}
