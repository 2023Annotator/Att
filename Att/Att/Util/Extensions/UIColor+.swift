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
    
}
