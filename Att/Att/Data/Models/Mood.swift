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
    
    var description: String {
        switch self {
        case .joy:
            return "기쁨"
        case .sadness:
            return "슬픔"
        case .anger:
            return "분노"
        case .calm:
            return "평온"
        case .surprise:
            return "즐거움"
        case .fear:
            return "공포"
        }
    }
    
    var subDescription: String {
        switch self {
        case .joy:
            return "joy"
        case .sadness:
            return "sadness"
        case .anger:
            return "anger & disgust"
        case .calm:
            return "calm & trust"
        case .surprise:
            return "Surprise & Anticipation"
        case .fear:
            return "fear"
        }
    }
    
    mutating func changeMoodWithAngle(angle: CGFloat) {
        switch angle {
        case 0..<60:
            self = .anger
        case 60..<120:
            self = .joy
        case 120..<180:
            self = .calm
        case 180..<240:
            self = .sadness
        case 240..<300:
            self = .fear
        case 300..<360:
            self = .surprise
        default:
            break
        }
    }
    
    mutating func changeMoodWithSliderValue(value: Float) {
        let angleValue = value * 3.6
        switch angleValue {
        case 0..<60:
            self = .anger
        case 60..<120:
            self = .joy
        case 120..<180:
            self = .calm
        case 180..<240:
            self = .sadness
        case 240..<300:
            self = .fear
        case 300..<360:
            self = .surprise
        default:
            break
        }
    }
}
