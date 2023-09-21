//
//  CircularTrig.swift
//  Att
//
//  Created by 정제인 on 2023/09/18.
//

import UIKit

open class CircularTrig {
    
    open class func angleRelativeToNorthFromPoint(_ fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
        var pointV = CGPoint(x: toPoint.x - fromPoint.x, y: toPoint.y - fromPoint.y)
        let vmag = CGFloat(sqrt(square(Double(pointV.x)) + square(Double(pointV.y))))
        pointV.x /= vmag
        pointV.y /= vmag
        let cartesianRadians = Double(atan2(pointV.y, pointV.x))
        var compassRadians = cartesianToCompass(cartesianRadians)
        if compassRadians < 0 {
            compassRadians += (2 * Double.pi)
        }
        assert(compassRadians >= 0 && compassRadians <= 2 * Double.pi, "angleRelativeToNorth should be always positive")
        return CGFloat(toDeg(compassRadians))
    }
    
    open class func pointOnRadius(_ radius: CGFloat, atAngleFromNorth: CGFloat) -> CGPoint {
        var result = CGPoint()
        let cartesianAngle = CGFloat(compassToCartesian(toRad(Double(atAngleFromNorth))))
        result.y = round(radius * sin(cartesianAngle))
        result.x = round(radius * cos(cartesianAngle))
        return result
    }
    
    open class func drawFilledCircleInContext(_ ctx: CGContext, center: CGPoint, radius: CGFloat) -> CGRect {
        let frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        ctx.fillEllipse(in: frame)
        return frame
    }
    
    open class func drawUnfilledCircleInContext(_ ctx: CGContext, center: CGPoint, radius: CGFloat, lineWidth: CGFloat, maximumAngle: CGFloat, lineCap: CGLineCap) {
        drawBackgroundArcInContext(ctx, center: center, radius: radius, lineWidth: lineWidth, fromAngleFromNorth: 0, toAngleFromNorth: maximumAngle, lineCap: lineCap)
    }

    open class func drawBackgroundArcInContext(_ ctx: CGContext, center: CGPoint, radius: CGFloat, lineWidth: CGFloat, fromAngleFromNorth: CGFloat, toAngleFromNorth: CGFloat, lineCap: CGLineCap) {
        let cartesianFromAngle = compassToCartesian(toRad(Double(fromAngleFromNorth)))
        let cartesianToAngle = compassToCartesian(toRad(Double(toAngleFromNorth)))
        
        ctx.addArc(
            center: CGPoint(x: center.x, y: center.y),
            radius: radius,
            startAngle: CGFloat(cartesianFromAngle),
            endAngle: CGFloat(cartesianToAngle),
            clockwise: false)
        
        ctx.setLineWidth(lineWidth)
        ctx.setLineCap(lineCap)
        ctx.drawPath(using: CGPathDrawingMode.stroke)
        
    }
}

extension CircularTrig {
    
    fileprivate class func toRad(_ degrees: Double) -> Double {
        return ((Double.pi * degrees) / 180.0)
    }
    
    fileprivate class func toDeg(_ radians: Double) -> Double {
        return ((180.0 * radians) / Double.pi)
    }
    
    fileprivate class func square(_ value: Double) -> Double {
        return value * value
    }
    
    fileprivate class func cartesianToCompass(_ radians: Double) -> Double {
        return radians + (Double.pi/2)
    }
    
    fileprivate class func compassToCartesian(_ radians: Double) -> Double {
        return radians - (Double.pi/2)
    }
}
