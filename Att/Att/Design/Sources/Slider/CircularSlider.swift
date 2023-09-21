//
//  ColorPickerView.swift
//  Att
//
//  Created by 정제인 on 2023/09/11.
//

import Combine
import UIKit

final class CircularSlider: UIControl {
    
    var minimumValue: Float = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var maximumValue: Float = 100.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var maximumAngle: CGFloat = 360.0 {
        didSet {
            if maximumAngle > 360.0 {
                print("Warning: Maximum angle should be 360 or less.")
                maximumAngle = 360.0
            }
            setNeedsDisplay()
        }
    }
    
    var currentValue: Float {
        set {
            assert(newValue <= maximumValue && newValue >= minimumValue, "current value \(newValue) must be between minimumValue \(minimumValue) and maximumValue \(maximumValue)")
            angleFromNorth = Int((newValue * Float(maximumAngle)) / (maximumValue - minimumValue))
            moveHandle(CGFloat(angleFromNorth))
            sendActions(for: UIControl.Event.valueChanged)
        } get {
            return (Float(angleFromNorth) * (maximumValue - minimumValue)) / Float(maximumAngle)
        }
    }
    
    let circularSliderHandle = CircularSliderHandle()
    
    var handleColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineWidth: Int = 5 {
        didSet {
            setNeedsUpdateConstraints()
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    var backgroundMood: Mood = Mood.anger {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var backgroundArcLineCap: CGLineCap = .butt
    
    var computedRadius: CGFloat {
        if radius == -1.0 {
            let minimumDimension = min(bounds.size.height, bounds.size.width)
            let halfLineWidth = ceilf(Float(lineWidth) / 2.0)
            let halfHandleWidth = ceilf(Float(handleWidth) / 2.0)
            return minimumDimension * 0.5 - CGFloat(max(halfHandleWidth, halfLineWidth))
        }
        return radius
    }
    
    var centerPoint: CGPoint {
        return CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
    }
    
    var angleFromNorth: Int = 0 {
        didSet {
            assert(angleFromNorth >= 0, "angleFromNorth \(angleFromNorth) must be greater than 0")
        }
    }
    
    var handleWidth: CGFloat {
        return CGFloat(lineWidth)
    }
    
    fileprivate var radius: CGFloat = -1.0 {
        didSet {
            setNeedsUpdateConstraints()
            setNeedsDisplay()
        }
    }
    
    fileprivate var computedHandleColor: UIColor? {
        let newHandleColor = UIColor.white
        return newHandleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override var intrinsicContentSize: CGSize {
        let diameter = radius * 2
        let halfLineWidth = ceilf(Float(lineWidth) / 2.0)
        let halfHandleWidth = ceilf(Float(handleWidth) / 2.0)
        let widthWithHandle = diameter + CGFloat(2 *  max(halfHandleWidth, halfLineWidth))
        return CGSize(width: widthWithHandle, height: widthWithHandle)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let ctx = UIGraphicsGetCurrentContext()
        
        drawLine(ctx!)
        
        let handleCenter = pointOnCircleAtAngleFromNorth(angleFromNorth)
        circularSliderHandle.frame = drawHandle(ctx!, atPoint: handleCenter)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard event != nil else { return false }
        
        if pointInsideHandle(point, withEvent: event!) {
            return true
        } else {
            return pointInsideCircle(point, withEvent: event!)
        }
    }
    
    fileprivate func pointInsideCircle(_ point: CGPoint, withEvent event: UIEvent) -> Bool {
        let point1 = centerPoint
        let point2 = point
        let xDist = point2.x - point1.x
        let yDist = point2.y - point1.y
        let distance = sqrt((xDist * xDist) + (yDist * yDist))
        return distance < computedRadius + CGFloat(lineWidth) * 0.5
    }
    
    fileprivate func pointInsideHandle(_ point: CGPoint, withEvent event: UIEvent) -> Bool {
        let handleCenter = pointOnCircleAtAngleFromNorth(angleFromNorth)
        let handleRadius = max(handleWidth, 44.0) * 0.5
        
        let pointInsideHorzontalHandleBounds = (point.x >= handleCenter.x - handleRadius && point.x <= handleCenter.x + handleRadius)
        let pointInsideVerticalHandleBounds  = (point.y >= handleCenter.y - handleRadius && point.y <= handleCenter.y + handleRadius)
        return pointInsideHorzontalHandleBounds && pointInsideVerticalHandleBounds
    }
    
    func drawLine(_ ctx: CGContext) {
        backgroundMood.moodColor.set()
        CircularTrig.drawUnfilledCircleInContext(ctx, center: centerPoint, radius: computedRadius, lineWidth: CGFloat(lineWidth), maximumAngle: maximumAngle, lineCap: backgroundArcLineCap)
    }
    
    func drawHandle(_ ctx: CGContext, atPoint handleCenter: CGPoint) -> CGRect {
        ctx.saveGState()
        var frame: CGRect!
        
        handleColor = computedHandleColor
        handleColor!.set()
        
        frame = CircularTrig.drawFilledCircleInContext(ctx, center: handleCenter, radius: handleWidth/2)
        
        ctx.saveGState()
        return frame
    }
    
    // MARK: - UIControl Functions
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let lastPoint = touch.location(in: self)
        let lastAngle = floor(CircularTrig.angleRelativeToNorthFromPoint(centerPoint, toPoint: lastPoint))

        moveHandle(lastAngle)
        backgroundMood.changeMoodWithAngle(angle: lastAngle)
        sendActions(for: UIControl.Event.valueChanged)
        
        return true
    }
    
    fileprivate func moveHandle(_ newAngleFromNorth: CGFloat) {
        if newAngleFromNorth > maximumAngle {
            if angleFromNorth < Int(maximumAngle / 2) {
                angleFromNorth = 0
                setNeedsDisplay()
            } else if angleFromNorth > Int(maximumAngle / 2) {
                angleFromNorth = Int(maximumAngle)
                setNeedsDisplay()
            }
        } else {
            angleFromNorth = Int(newAngleFromNorth)
        }
        setNeedsDisplay()
    }
    
    func pointOnCircleAtAngleFromNorth(_ angleFromNorth: Int) -> CGPoint {
        let offset = CircularTrig.pointOnRadius(computedRadius, atAngleFromNorth: CGFloat(angleFromNorth))
        return CGPoint(x: centerPoint.x + offset.x, y: centerPoint.y + offset.y)
    }
}
