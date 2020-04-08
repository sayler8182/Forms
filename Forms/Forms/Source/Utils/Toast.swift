//
//  Toast.swift
//  Forms
//
//  Created by Konrad on 4/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Configuration
public protocol ConfigurationToastProtocol {
    var lifeTime: TimeInterval { get }
    var backgroundColor: ToastStyle<UIColor> { get }
    var titleColor: ToastStyle<UIColor> { get }
    var titleFont: ToastStyle<UIFont> { get }
    var toastView: () -> ToastView { get }
}

public extension Configuration {
    struct Toast: ConfigurationToastProtocol {
        public var lifeTime: TimeInterval = 3
        public var backgroundColor = ToastStyle(
            info: UIColor.black,
            success: UIColor.green,
            error: UIColor.red)
        public var titleColor = ToastStyle(
            info: UIColor.white,
            success: UIColor.black,
            error: UIColor.white)
        public var titleFont = ToastStyle(UIFont.boldSystemFont(ofSize: 14))
        public var toastView: () -> ToastView = { ToastView() }
    }
}

// MARK: Style
public enum ToastStyleType {
    case info
    case success
    case error
}

public class ToastStyle<T> {
    var info: T
    var success: T
    var error: T
    
    init(_ value: T) {
        self.info = value
        self.success = value
        self.error = value
    }
    
    init(info: T, success: T, error: T) {
        self.info = info
        self.success = success
        self.error = error
    }
    
    func value(for style: ToastStyleType) -> T {
        switch style {
        case .info: return self.info
        case .success: return self.success
        case .error: return self.error
        }
    }
}

// MARK: Position
public enum ToastPosition {
    case top
    case bottom
}

// MARK: ToastKey
public protocol ToastKey {
    var rawValue: String { get }
}

// MARK: Toast
public enum Toast {
    @Injected
    public static var configuration: ConfigurationToastProtocol // swiftlint:disable:this let_var_whitespace
    
    public static func new() -> ToastView {
        return Toast.configuration.toastView()
    }
    
    public static func new<T: ToastView>(of type: T.Type) -> T {
        return T()
    }
}

// MARK: ToastView
open class ToastView: Component {
    public let titleLabel = UILabel()
    public let contentView = UIView()
    private let gestureRecognizer = UITapGestureRecognizer()
    
    public var isDismissable: Bool = true
    public var position: ToastPosition = .top
    public var style: ToastStyleType = .info
    public var key: ToastKey? = nil
    public var lifeTime: TimeInterval?
    private var lifeTimer: Timer? = nil
    
    var onDismiss: ((ToastView) -> Void)? = nil
    
    override public required init() {
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    public func show(in context: UIViewController?,
                     animated: Bool = true,
                     completion: ((Bool) -> Void)? = nil) -> Self {
        return self.show(
            in: context?.view,
            animated: animated,
            completion: completion)
    }
    
    @discardableResult
    public func show(in context: UIView?,
                     animated: Bool = true,
                     completion: ((Bool) -> Void)? = nil) -> Self {
        guard let context: UIView = context else { return self }
        self.addContent(to: context)
        self.add(to: context)
        self.layoutIfNeeded()
        self.show(
            animated: animated,
            completion: completion)
        let lifeTime: TimeInterval = self.lifeTime.or(Toast.configuration.lifeTime)
        self.lifeTimer = Timer.scheduledTimer(withTimeInterval: lifeTime, repeats: false, block: { [weak self] (_) in
            guard let `self` = self else { return }
            self.hide(animated: true, completion: nil)
        })
        return self
    }
    
    private func addContent(to parent: UIView) {
        switch self.position {
        case .top:
            parent.addSubview(self, with: [
                Anchor.to(parent).top,
                Anchor.to(parent).horizontal
            ])
            self.addSubview(self.contentView, with: [
                Anchor.to(self).top.offset(max(16, UIView.safeArea.top)),
                Anchor.to(self).horizontal.offset(16),
                Anchor.to(self).bottom.offset(16)
            ])
        case .bottom:
            parent.addSubview(self, with: [
                Anchor.to(parent).horizontal,
                Anchor.to(parent).bottom
            ])
            self.addSubview(self.contentView, with: [
                Anchor.to(self).top.offset(16),
                Anchor.to(self).horizontal.offset(16),
                Anchor.to(self).bottom.offset(max(16, UIView.safeArea.bottom))
            ])
        }
    }
    
    override public func setupActions() {
        self.gestureRecognizer.addTarget(self, action: #selector(handleGesture))
        self.addGestureRecognizer(self.gestureRecognizer)
    }
    
    @objc
    private func handleGesture(recognizer: UITapGestureRecognizer) {
        guard self.isDismissable else { return }
        self.lifeTimer?.invalidate()
        if let onDismiss = self.onDismiss {
            onDismiss(self)
        } else {
            self.hide(animated: true, completion: nil)
        }
    }
    
    // MARK: HOOKS
    open func add(to parent: UIView) {
        self.backgroundColor = Toast.configuration.backgroundColor.value(for: self.style)
        self.titleLabel.textColor = Toast.configuration.titleColor.value(for: self.style)
        self.titleLabel.font = Toast.configuration.titleFont.value(for: self.style)
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 4
        self.contentView.addSubview(self.titleLabel, with: [
            Anchor.to(self.contentView).fill
        ])
    }
    
    open func show(animated: Bool,
                   completion: ((Bool) -> Void)?) {
        guard let context: UIView = self.superview else { return }
        let startPosition: CGPoint
        let endPosition: CGPoint
        switch self.position {
        case .top:
            startPosition = CGPoint(x: 0, y: -self.frame.height)
            endPosition = CGPoint(x: 0, y: 0)
        case .bottom:
            startPosition = CGPoint(x: 0, y: context.frame.height)
            endPosition = CGPoint(x: 0, y: context.frame.height - self.frame.height)
        }
        self.frame.origin = startPosition
        self.animation(
            animated,
            duration: 0.3,
            animations: {
                self.frame.origin = endPosition
        }, completion: completion)
    }
    
    open func hide(animated: Bool,
                   completion: ((Bool) -> Void)?) {
        let endPosition: CGPoint
        switch self.position {
        case .top:
            endPosition = CGPoint(x: 0, y: -self.frame.height)
        case .bottom:
            endPosition = CGPoint(x: 0, y: self.frame.origin.y + self.frame.height)
        }
        self.animation(
            animated,
            duration: 0.3,
            animations: {
                self.frame.origin = endPosition
        }, completion: { (status) in
            self.removeFromSuperview()
            completion?(status)
        })
    }
}

// MARK: Builder
public extension ToastView {
    func with(isDismissable: Bool) -> Self {
        self.isDismissable = isDismissable
        return self
    }
    func with(key: ToastKey) -> Self {
        self.key = key
        return self
    }
    func with(lifeTime: TimeInterval) -> Self {
        self.lifeTime = lifeTime
        return self
    }
    func with(position: ToastPosition) -> Self {
        self.position = position
        return self
    }
    func with(style: ToastStyleType) -> Self {
        self.style = style
        return self
    }
    func with(title: String?) -> Self {
        self.titleLabel.text = title
        return self
    }
    func with(titleAlignment: NSTextAlignment) -> Self {
        self.titleLabel.textAlignment = titleAlignment
        return self
    }
    func with(titleNumberOfLines: Int) -> Self {
        self.titleLabel.numberOfLines = titleNumberOfLines
        return self
    }
}
