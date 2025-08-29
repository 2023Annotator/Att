//
//  GradientFadeView.swift
//  Att
//
//  Created by 황정현 on 8/29/25.
//

import UIKit

final class GradientFadeView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }
    
    private var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        configure()
        
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_ view: GradientFadeView, _ previous: UITraitCollection) in
                view.configure()
            }
        }
    }
    
    private func configure() {
        let base = UIColor.white
        
        gradientLayer?.colors = [
            base.withAlphaComponent(1.0).cgColor,
            base.withAlphaComponent(0.85).cgColor,
            base.withAlphaComponent(0.35).cgColor,
            base.withAlphaComponent(0.0).cgColor
        ]
        
        gradientLayer?.locations  = [0.0, 0.35, 0.72, 1.0]
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer?.endPoint   = CGPoint(x: 0.5, y: 0.0)
        gradientLayer?.frame = bounds
        
        self.isUserInteractionEnabled = false
    }
}
