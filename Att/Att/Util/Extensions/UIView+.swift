//
//  UIView+.swift
//  Att
//
//  Created by 황정현 on 2023/09/20.
//

import UIKit.UIView

extension UIView {
    func rotateClockwise45Degrees(_ completion: @escaping (Bool) -> Void) {
        let rotationAngle: CGFloat = .pi / 4
        let duration: TimeInterval = 1.0
        let delay: TimeInterval = 0.3
        
        UIView.animate(withDuration: duration, delay: delay, animations: { [weak self] in
            guard let self = self else { return }
            self.transform = self.transform.rotated(by: rotationAngle)
        }, completion: completion)
    }
}
