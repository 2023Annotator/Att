//
//  DottedLineView.swift
//  Att
//
//  Created by 황정현 on 2023/09/11.
//

import UIKit

final class DottedLineView: UIView {
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    init() {
        super.init(frame: CGRect.zero)
        configureDottedLine()
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureDottedLine() {
        
        let width = UIScreen.main.bounds.width - 30
        let height: CGFloat = 32
        guard let shapeLayer = self.layer as? CAShapeLayer else { return }
        
        shapeLayer.lineWidth = 1.0
        shapeLayer.lineDashPattern = [2, 2]
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addLine(to: CGPoint(x: width, y: height / 2))
        
        shapeLayer.path = path.cgPath
    }
    
    func setUpLineColor(color: UIColor) {
        guard let shapeLayer = self.layer as? CAShapeLayer else { return }
        shapeLayer.strokeColor = color.cgColor
    }
}
