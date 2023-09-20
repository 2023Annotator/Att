//
//  CircularTrig.swift
//  Att
//
//  Created by 정제인 on 2023/09/18.
//

import UIKit

open class CircularTrig {
    
    open class func angleRelativeToNorthFromPoint(_ fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
        var v = CGPoint(x: toPoint.x - fromPoint.x, y: toPoint.y - fromPoint.y)
        let vmag = CGFloat(sqrt(square(Double(v.x)) + square(Double(v.y))))
        v.x /= vmag
        v.y /= vmag
        let cartesianRadians = Double(atan2(v.y, v.x))
        var compassRadians = cartesianToCompass(cartesianRadians)
        if (compassRadians < 0) {
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
        drawUnfilledArcInContext(ctx, center: center, radius: radius, lineWidth: lineWidth, fromAngleFromNorth: 0, toAngleFromNorth: maximumAngle, lineCap: lineCap)
    }
    
    open class func drawUnfilledArcInContext(_ ctx: CGContext, center: CGPoint, radius: CGFloat, lineWidth: CGFloat, fromAngleFromNorth: CGFloat, toAngleFromNorth: CGFloat, lineCap: CGLineCap) {
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
    
    open class func drawUnfilledGradientArcInContext(_ ctx: CGContext, center: CGPoint, radius: CGFloat, lineWidth: CGFloat, maximumAngle: CGFloat, colors: [UIColor], lineCap: CGLineCap) {
        guard colors.count == 2 else {
            return
        }
        
        let cartesianFromAngle = compassToCartesian(toRad(Double(0)))
        let cartesianToAngle = compassToCartesian(toRad(Double(maximumAngle)))
        
        ctx.saveGState()
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(cartesianFromAngle), endAngle: CGFloat(cartesianToAngle), clockwise: true)
        let containerPath = CGPath(__byStroking: path.cgPath, transform: nil, lineWidth: CGFloat(lineWidth), lineCap: lineCap, lineJoin: CGLineJoin.round, miterLimit: lineWidth)
        if let containerPath = containerPath {
            ctx.addPath(containerPath)
        }
        ctx.clip()
        
        let baseSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [colors[1].cgColor, colors[0].cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: baseSpace, colors: colors, locations: nil)
        let startPoint = CGPoint(x: center.x - radius, y: center.y + radius)
        let endPoint = CGPoint(x: center.x + radius, y: center.y - radius)
        if let gradient = gradient {
            ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
        }
        ctx.restoreGState()
    }
    
    open class func degreesForArcLength(_ arcLength: CGFloat, onCircleWithRadius radius: CGFloat, withMaximumAngle degrees: CGFloat) -> CGFloat {
        let totalCircumference = CGFloat(2 * Double.pi) * radius
        let arcRatioToCircumference = arcLength / totalCircumference
        
        return degrees * arcRatioToCircumference
    }
    
    open class func outerRadiuOfUnfilledArcWithRadius(_ radius: CGFloat, lineWidth: CGFloat) -> CGFloat {
        return radius + 0.5 * lineWidth
    }
    
    open class func innerRadiusOfUnfilledArcWithRadius(_ radius :CGFloat, lineWidth: CGFloat) -> CGFloat {
        return radius - 0.5 * lineWidth
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
