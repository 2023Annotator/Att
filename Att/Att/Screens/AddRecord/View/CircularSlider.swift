//
//  ColorPickerView.swift
//  Att
//
//  Created by 정제인 on 2023/09/11.
//

import UIKit
import QuartzCore
import Foundation

enum CircularSliderHandleType {
    case semiTransparentWhiteSmallCircle,
         semiTransparentWhiteCircle,
         semiTransparentBlackCircle,
         bigCircle
}

class CircularSlider: UIControl {
    
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
    
    var handleType: CircularSliderHandleType = .semiTransparentWhiteSmallCircle {
        didSet {
            setNeedsUpdateConstraints()
            setNeedsDisplay()
        }
    }
    
    var snapToLabels: Bool = false
    
    var innerMarkingLabels: [String]? {
        didSet {
            setNeedsUpdateConstraints()
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
    
    var filledColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var unfilledColor: UIColor = .cherry {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var labelFont: UIFont = .systemFont(ofSize: 10.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var labelColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var labelDisplacement: CGFloat = 0
    
    var unfilledArcLineCap: CGLineCap = .butt
    
    var filledArcLineCap: CGLineCap = .butt
    
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
        switch handleType {
        case .semiTransparentWhiteSmallCircle:
            return CGFloat(lineWidth / 2)
        case .semiTransparentWhiteCircle, .semiTransparentBlackCircle:
            return CGFloat(lineWidth)
        case .bigCircle:
            return CGFloat(lineWidth + 5)
        }
    }
    
    fileprivate var radius: CGFloat = -1.0 {
        didSet {
            setNeedsUpdateConstraints()
            setNeedsDisplay()
        }
    }
    
    fileprivate var computedHandleColor: UIColor? {
        var newHandleColor = handleColor
        switch handleType {
        case .semiTransparentWhiteSmallCircle, .semiTransparentWhiteCircle:
            newHandleColor = UIColor(white: 1.0, alpha: 0.7)
        case .semiTransparentBlackCircle:
            newHandleColor = UIColor(white: 0.0, alpha: 0.7)
        case .bigCircle:
            newHandleColor = filledColor
        }
        return newHandleColor
    }
    
    fileprivate var innerLabelRadialDistanceFromCircumference: CGFloat {
        var distanceToMoveInwards = 0.1 * -(radius) - 0.5 * CGFloat(lineWidth)
        distanceToMoveInwards -= 0.5 * labelFont.pointSize
        return distanceToMoveInwards
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
        
        drawInnerLabels(ctx!, rect: rect)
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
        unfilledColor.set()
        CircularTrig.drawUnfilledCircleInContext(ctx, center: centerPoint, radius: computedRadius, lineWidth: CGFloat(lineWidth), maximumAngle: maximumAngle, lineCap: unfilledArcLineCap)
        
        filledColor.set()
        CircularTrig.drawUnfilledArcInContext(ctx, center: centerPoint, radius: computedRadius, lineWidth: CGFloat(lineWidth), fromAngleFromNorth: 0, toAngleFromNorth: CGFloat(angleFromNorth), lineCap: filledArcLineCap)
    }
    
    func drawHandle(_ ctx: CGContext, atPoint handleCenter: CGPoint) -> CGRect {
        ctx.saveGState()
        var frame: CGRect!
        
        handleColor = computedHandleColor
        handleColor!.set()
        
        frame = CircularTrig.drawFilledCircleInContext(ctx, center: handleCenter, radius: 0.5 * handleWidth)
        
        ctx.saveGState()
        return frame
    }
    
    func drawInnerLabels(_ ctx: CGContext, rect: CGRect) {
        if let labels = innerMarkingLabels, labels.count > 0 {
            let attributes = [NSAttributedString.Key.font: labelFont, NSAttributedString.Key.foregroundColor: labelColor]
            
            for (index, label) in labels.enumerated() {
                let labelFrame = contextCoordinatesForLabel(atIndex: index)
                
                ctx.saveGState()
                ctx.concatenate(CGAffineTransform(translationX: labelFrame.origin.x + (labelFrame.width / 2), y: labelFrame.origin.y + (labelFrame.height / 2)))
                ctx.concatenate(getRotationalTransform().inverted())
                ctx.concatenate(CGAffineTransform(translationX: -(labelFrame.origin.x + (labelFrame.width / 2)), y: -(labelFrame.origin.y + (labelFrame.height / 2))))
                label.draw(in: labelFrame, withAttributes: attributes)
                ctx.restoreGState()
            }
        }
    }
    
    func contextCoordinatesForLabel(atIndex index: Int) -> CGRect {
        let label = innerMarkingLabels![index]
        var percentageAlongCircle: CGFloat!
        
        if maximumAngle == 360.0 {
            percentageAlongCircle = ((100.0 / CGFloat(innerMarkingLabels!.count)) * CGFloat(index + 1)) / 100.0
        } else {
            percentageAlongCircle = ((100.0 / CGFloat(innerMarkingLabels!.count - 1)) * CGFloat(index)) / 100.0
        }
        
        let degreesFromNorthForLabel = percentageAlongCircle * maximumAngle
        let pointOnCircle = pointOnCircleAtAngleFromNorth(Int(degreesFromNorthForLabel))
        let labelSize = sizeOfString(label, withFont: labelFont)
        let offsetFromCircle = offsetFromCircleForLabelAtIndex(index, withSize: labelSize)
        
        return CGRect(x: pointOnCircle.x + offsetFromCircle.x, y: pointOnCircle.y + offsetFromCircle.y, width: labelSize.width, height: labelSize.height)
    }
    
    func offsetFromCircleForLabelAtIndex(_ index: Int, withSize labelSize: CGSize) -> CGPoint {
        let percentageAlongCircle = ((100.0 / CGFloat(innerMarkingLabels!.count - 1)) * CGFloat(index)) / 100.0
        let degreesFromNorthForLabel = percentageAlongCircle * maximumAngle
        let radialDistance = innerLabelRadialDistanceFromCircumference + labelDisplacement
        let inwardOffset = CircularTrig.pointOnRadius(radialDistance, atAngleFromNorth: CGFloat(degreesFromNorthForLabel))
        
        return CGPoint(x: -labelSize.width * 0.5 + inwardOffset.x, y: -labelSize.height * 0.5 + inwardOffset.y)
    }
    
    // MARK: - UIControl Functions
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let lastPoint = touch.location(in: self)
        let lastAngle = floor(CircularTrig.angleRelativeToNorthFromPoint(centerPoint, toPoint: lastPoint))
        
        moveHandle(lastAngle)
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
    
    func sizeOfString(_ string: String, withFont font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return NSAttributedString(string: string, attributes: attributes).size()
    }
    
    func getRotationalTransform() -> CGAffineTransform {
        if maximumAngle == 360 {
            let transform = CGAffineTransform.identity.rotated(by: CGFloat(0))
            return transform
        } else {
            let radians = Double(-(maximumAngle / 2)) / 180.0 * Double.pi
            let transform = CGAffineTransform.identity.rotated(by: CGFloat(radians))
            return transform
        }
    }
}
