//
//  GradientCircularSlider.swift
//  Att
//
//  Created by 정제인 on 2023/09/18.
//

import UIKit

class GradientCircularSlider: CircularSlider {
    // Array with two colors to create gradation between
    var unfilledGradientColors: [UIColor] = [.black, .lightGray] {
      didSet {
        setNeedsDisplay()
      }
    }
    
    override func drawLine(_ ctx: CGContext) {
      if unfilledGradientColors.count == 2 {
        CircularTrig.drawUnfilledGradientArcInContext(ctx, center: centerPoint, radius: computedRadius, lineWidth: CGFloat(lineWidth), maximumAngle: maximumAngle , colors: unfilledGradientColors, lineCap: unfilledArcLineCap)
      } else {
        print("The array 'colors' must contain exactly two colors to create a gradient")
      }
    }
}
