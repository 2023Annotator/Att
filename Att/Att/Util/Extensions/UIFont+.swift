//
//  UIFont+.swift
//  Att
//
//  Created by 황정현 on 2023/07/15.
//

import UIKit

enum FontWeight {
    case bold, regular
}

extension UIFont {
    convenience init?(weight: FontWeight, size: CGFloat) {
        switch weight {
        case .bold:
            self.init(name: "WixMadeforDisplay-Bold", size: size)
        case .regular:
            self.init(name: "Pretendard-Regular", size: size)
        }
    }
    
    static let title0 = UIFont(weight: .bold, size: 36)
    static let title1 = UIFont(weight: .bold, size: 32)
    static let title2 = UIFont(weight: .bold, size: 28)
    static let title3 = UIFont(weight: .bold, size: 22)
    
    static let subtitle1 = UIFont(weight: .regular, size: 28)
    static let subtitle2 = UIFont(weight: .regular, size: 24)
    static let subtitle3 = UIFont(weight: .regular, size: 18)
    static let caption1 = UIFont(weight: .regular, size: 16)
    static let caption2 = UIFont(weight: .regular, size: 14)
    static let caption3 = UIFont(weight: .regular, size: 12)
}
