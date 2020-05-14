//
//  UIView.swift
//  Utils
//
//  Created by Konrad on 3/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: UIView
public extension UIView {
    static var isRightToLeft: Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    static var safeArea: UIEdgeInsets {
        if #available(iOS 13.0, *) {
            let _window: UIWindow? = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
            guard let window: UIWindow = _window else { return UIEdgeInsets(0) }
            return window.safeAreaInsets
        } else if #available(iOS 11.0, *) {
            guard let _window: UIWindow? = UIApplication.shared.delegate?.window,
                let window: UIWindow = _window else { return UIEdgeInsets(0) }
            return window.safeAreaInsets
        } else {
            return UIEdgeInsets(0)
        }
    }
    
    var parentController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            guard let controller = responder as? UIViewController else { continue }
            return controller
        }
        return nil
    }
    
    var parentNavigationController: UINavigationController? {
        let parentController: UIViewController? = self.parentController
        if let navigationController = parentController as? UINavigationController {
            return navigationController
        } else {
            return parentController?.navigationController
        }
    }
    
    var flatSubviews: [UIView] {
        var subviews: [UIView] = self.subviews
        guard !subviews.isEmpty else { return [] }
        for subview in subviews {
            subviews.append(contentsOf: subview.flatSubviews)
        }
        return subviews
    }
    
    convenience init(width: CGFloat,
                     height: CGFloat) {
        self.init(frame: CGRect(width: width, height: height))
    }
    
    func removeSubviews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func setAlpha(alpha: CGFloat,
                  duration: TimeInterval = 0.0,
                  animated: Bool = true,
                  completion: ((Bool) -> Void)? = nil) {
        self.animation(
            animated,
            duration: duration,
            animations: { self.alpha = alpha },
            completion: completion)
    }
    
    func setCornerRadius(corners: UIRectCorner = .allCorners,
                         radius: CGFloat) {
        let path: UIBezierPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(size: radius))
        let mask: CAShapeLayer = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setShadow(color: UIColor = UIColor.black,
                   opacity: Float = 0.10,
                   offset: CGSize = CGSize.zero,
                   radius: CGFloat = 6,
                   cornerRadius: CGFloat = 0,
                   scale: Bool = true,
                   rasterize: Bool = true,
                   masksToBounds: Bool = false) {
        self.layer.masksToBounds = masksToBounds
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        
        guard rasterize else { return }
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func animation(_ animated: Bool,
                   duration: TimeInterval,
                   delay: TimeInterval = 0.0,
                   options: UIView.AnimationOptions = .allowUserInteraction,
                   animations: @escaping (() -> Void)) {
        self.animation(
            animated,
            duration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: nil)
    }
    
    func animation(_ animated: Bool,
                   duration: TimeInterval,
                   delay: TimeInterval = 0.0,
                   options: UIView.AnimationOptions = .allowUserInteraction,
                   animations: @escaping (() -> Void) = { },
                   completion: ((Bool) -> Void)? = nil) {
        guard animated else {
            animations()
            return
        }
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: completion)
    }
    
    func transition(_ animated: Bool,
                    duration: TimeInterval,
                    options: UIView.AnimationOptions = [.allowUserInteraction, .transitionCrossDissolve],
                    animations: @escaping (() -> Void)) {
        self.transition(
            animated,
            duration: duration,
            options: options,
            animations: animations,
            completion: nil)
    }
    
    func transition(_ animated: Bool,
                    duration: TimeInterval,
                    options: UIView.AnimationOptions = [.allowUserInteraction, .transitionCrossDissolve],
                    animations: @escaping (() -> Void) = { },
                    completion: ((Bool) -> Void)? = nil) {
        guard animated else {
            animations()
            return
        }
        
        UIView.transition(
            with: self,
            duration: duration,
            options: options,
            animations: animations,
            completion: completion)
    }
    
    func shouldAnimate(_ animated: Bool,
                       action: () -> Void) {
        animated
            ? action()
            : UIView.performWithoutAnimation(action)
    }
}

// MARK: [UIView]
public extension Array where Element == UIView {
    func removeFromSuperview() {
        for view in self {
            view.removeFromSuperview()
        }
    }
}

// MARK: Builder
extension UIView {
    @objc
    open func rounded() -> Self {
        let cornerRadius: CGFloat = min(self.bounds.width, self.bounds.height)
        self.setCornerRadius(radius: cornerRadius)
        return self
    }
    
    @objc
    open func with(backgroundColor: UIColor?) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    
    @objc
    open func with(clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }
             
    @objc
    open func with(contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    @objc
    open func with(cornerRadius: CGFloat, asPath: Bool = false) -> Self {
        if asPath {
            self.setCornerRadius(radius: cornerRadius)
        } else {
            self.layer.cornerRadius = cornerRadius
        }
        return self
    }
    
    @objc
    open func with(height: CGFloat) -> Self {
        return self.with(width: self.frame.size.width, height: height)
    }
    
    @objc
    open func with(isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    
    @objc
    open func with(origin: CGPoint) -> Self {
        self.frame.origin = origin
        return self
    }
    
    @objc
    open func with(size: CGSize) -> Self {
        self.frame.size = size
        return self
    }
    
    @objc
    open func with(width: CGFloat) -> Self {
        return self.with(width: width, height: self.frame.size.height)
    }
    
    @objc
    open func with(width: CGFloat,
                   height: CGFloat) -> Self {
        self.frame.size.width = width
        self.frame.size.height = height
        return self
    }
    
    @objc
    open func withShadow(color: UIColor = UIColor.black,
                         opacity: Float = 0.10,
                         offset: CGSize = CGSize.zero,
                         radius: CGFloat = 6,
                         cornerRadius: CGFloat = 0,
                         scale: Bool = true,
                         rasterize: Bool = true,
                         masksToBounds: Bool = false) -> Self {
        self.setShadow(
            color: color,
            opacity: opacity,
            offset: offset,
            radius: radius,
            cornerRadius: cornerRadius,
            scale: scale,
            rasterize: rasterize,
            masksToBounds: masksToBounds)
        return self
    }
}
