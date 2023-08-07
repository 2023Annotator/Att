//
//  UIColor+.swift
//  Att
//
//  Created by 황정현 on 2023/07/15.
//

import UIKit

extension UIColor {
    
    convenience init(rgb: Int) {
           self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1
           )
    }
    
    static let cherry = UIColor(rgb: 0xF94A74)
    static let yellow = UIColor(rgb: 0xFFD771)
    static let yellowGreen = UIColor(rgb: 0x99F89C)
    static let green = UIColor(rgb: 0x78DCBE)
    static let blue = UIColor(rgb: 0x6DAAFB)
    static let purpleBlue = UIColor(rgb: 0x536FFA)
    static let purple = UIColor(rgb: 0x7E5DEA)
    static let pink = UIColor(rgb: 0xFFAEFD)
    static let gray100 = UIColor(rgb: 0x434343)
    static let gray50 = UIColor(rgb: 0xAAAAAA)
    static let white = UIColor(rgb: 0xFFFFFE)
    static let black = UIColor(rgb: 0x0D0D0D)
}
