//
//  UIImage+.swift
//  Att
//
//  Created by 황정현 on 2023/09/16.
//

import UIKit.UIImage

extension UIImage {
    func imageWithInset(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom), false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return nil
        }
        
        let origin = CGPoint(x: insets.left, y: insets.top)
        let rect = CGRect(origin: origin, size: size)
        context.draw(cgImage, in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
