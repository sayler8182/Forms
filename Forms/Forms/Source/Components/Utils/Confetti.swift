//
//  Confetti.swift
//  Forms
//
//  Created by Konrad on 6/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import QuartzCore
import UIKit

// MARK: ConfettiItem
public enum ConfettiItem {
    public enum Shape {
        case bezierPath(UIBezierPath)
        case circle
        case path(CGPath)
        case rectangle(CGFloat, CGFloat)
        case triangle
    }
    
    case image(UIImage, UIColor?)
    case shape(Shape, UIColor)
    case text(UIFont, String)
}

// MARK: Confetti
open class Confetti: FormsComponent, UnShimmerable, CAAnimationDelegate {
    private lazy var emitter: ConfettiLayer = ConfettiLayer()
    private var isActive: Bool = false
    private var timer: Timer? = nil
    
    open var color: UIColor = Theme.Colors.primaryDark
    open var duration: TimeInterval = 3.0
    open var intensity: CGFloat = 1.0
    open var items: [ConfettiItem] = []
    
    override open func setupView() {
        self.setupContent()
        super.setTheme()
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        guard self.isActive else { return }
        self.emitter.frame = self.bounds
    }
    
    override open func componentHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    open func setupContent() {
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    public func start() {
        let emitter: ConfettiLayer = ConfettiLayer()
        emitter.configure(
            intensity: self.intensity,
            items: self.items)
        emitter.frame = self.bounds
        emitter.needsDisplayOnBoundsChange = true
        self.layer.addSublayer(emitter)
        guard self.duration.isFinite else { return }
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAEmitterLayer.birthRate))
        animation.duration = self.duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.fillMode = .forwards
        animation.values = [1, 0, 0]
        animation.keyTimes = [0, 0.5, 1]
        animation.isRemovedOnCompletion = false
        emitter.beginTime = CACurrentMediaTime()
        emitter.birthRate = 1.0
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let transition = CATransition()
            transition.delegate = self
            transition.type = .fade
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.setValue(emitter, forKey: "com.limbo.Forms.Utils")
            transition.isRemovedOnCompletion = false
            emitter.add(transition, forKey: nil)
            emitter.opacity = 0
        }
        emitter.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    public func stop() {
        self.emitter.birthRate = 0
        self.timer?.invalidate()
        self.isActive = false
    }
    
    public func slow(after: TimeInterval) {
        let timer: Timer = Timer(
            timeInterval: after,
            target: self,
            selector: #selector(timerTick),
            userInfo: nil,
            repeats: false)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        self.timer = timer
    }
    
    public func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        if let layer = animation.value(forKey: "com.limbo.Forms.Utils") as? CALayer {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
    }
    
    @objc
    private func timerTick(_ timer: Timer) {
        let newBirthRate: Float = self.emitter.birthRate - 0.1
        if newBirthRate >= 0 {
            self.emitter.birthRate = newBirthRate
            self.slow(after: 0.1)
        } else {
            self.stop()
        }
    }
}

// MARK: Builder
public extension Confetti {
    func with(color: UIColor) -> Self {
        self.color = color
        return self
    }
    func with(intensity: CGFloat) -> Self {
        self.intensity = intensity
        return self
    }
    func with(items: [ConfettiItem]) -> Self {
        self.items = items
        return self
    }
}

// MARK: ConfettiLayer
private class ConfettiLayer: CAEmitterLayer {
    private var intensity: CGFloat = 1.0
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.emitterMode = .outline
        self.emitterShape = .line
        self.emitterSize = CGSize(width: self.frame.size.width, height: 1.0)
        self.emitterPosition = CGPoint(x: self.frame.size.width / 2.0, y: 0)
    }
    
    func configure(intensity: CGFloat,
                   items: [ConfettiItem]) {
        self.emitterCells = items.map { (item) in
            let cell: CAEmitterCell = CAEmitterCell()
            cell.birthRate = 5.0 * self.intensity.asFloat
            cell.lifetime = 7.0 * self.intensity.asFloat
            cell.velocity = 175.0 * self.intensity
            cell.velocityRange = 40.0 * self.intensity
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = 0.25 * self.intensity
            cell.spinRange = 2.0 * self.intensity
            cell.scale = 0.25 * self.intensity
            cell.scaleRange = 0.20 * self.intensity
            cell.scaleSpeed = -0.05 * self.intensity
            cell.scale = 1.0 - cell.scaleRange
            cell.contents = item.image.cgImage
            cell.color = item.color?.cgColor
            return cell
        }
    }
}

// MARK: ConfettiItem
fileprivate extension ConfettiItem {
    var color: UIColor? {
        switch self {
        case let .image(_, color): return color
        case let .shape(_, color): return color
        default: return nil
        }
    }
    
    var image: UIImage {
        switch self {
        case let .image(image, _):
            return image
        case let .shape(shape, color):
            return shape.image(with: color)
        case let .text(font, string):
            let defaultAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font
            ]
            return NSAttributedString(string: string, attributes: defaultAttributes).image()
        }
    }
}

// MARK: ConfettiItem.Shape
fileprivate extension ConfettiItem.Shape {
    func path(in rect: CGRect) -> CGPath {
        switch self {
        case .bezierPath(let path):
            return path.cgPath
        case .circle:
            return CGPath(ellipseIn: rect, transform: nil)
        case .path(let path):
            return path
        case .rectangle(let width, let height):
            let rect: CGRect = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
            return CGPath(rect: rect, transform: nil)
        case .triangle:
            let path = CGMutablePath()
            path.addLines(between: [
                CGPoint(x: rect.midX, y: 0),
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.midX, y: 0)
            ])
            return path
        }
    }
    
    func image(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: CGSize(width: 16.0, height: 16.0))
        return UIGraphicsImageRenderer(size: rect.size).image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.addPath(self.path(in: rect))
            context.cgContext.fillPath()
        }
    }
}

// MARK: NSAttributedString
fileprivate extension NSAttributedString {
    func image() -> UIImage {
        let size: CGSize = self.size()
        return UIGraphicsImageRenderer(size: size).image { _ in
            self.draw(at: .zero)
        }
    }
}
