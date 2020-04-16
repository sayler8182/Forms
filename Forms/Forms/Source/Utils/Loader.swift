//
//  Loader.swift
//  Forms
//
//  Created by Konrad on 4/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Configuration
public protocol ConfigurationLoaderProtocol {
    var backgroundColor: UIColor? { get }
    var loaderView: () -> LoaderView { get }
}

public extension Configuration {
    struct Loader: ConfigurationLoaderProtocol {
        public var backgroundColor: UIColor? = UIColor.black.withAlphaComponent(0.3)
        public var loaderView: () -> LoaderView = { DefaultLoaderView() }
    }
}

// MARK: Loader
public enum Loader {
    @Injected
    public static var configuration: ConfigurationLoaderProtocol // swiftlint:disable:this let_var_whitespace
    
    @discardableResult
    public static func show(in context: UIViewController?,
                            animated: Bool = true,
                            completion: ((Bool) -> Void)? = nil) -> LoaderView? {
        guard self.loader(for: context).isNil else { return nil }
        return self.show(
            in: context?.view,
            animated: animated,
            completion: completion)
    }
    
    @discardableResult
    public static func show<T: LoaderView>(in context: UIViewController?,
                                           of loaderType: T.Type,
                                           animated: Bool = true,
                                           completion: ((Bool) -> Void)? = nil) -> T? {
        guard self.loader(for: context).isNil else { return nil }
        return self.show(
            in: context?.view,
            of: loaderType,
            animated: animated,
            completion: completion)
    }
    
    @discardableResult
    public static func show(in context: UIView?,
                            animated: Bool = true,
                            completion: ((Bool) -> Void)? = nil) -> LoaderView? {
        guard self.loader(for: context).isNil else { return nil }
        guard let context: UIView = context else { return nil }
        let coverView = LoaderCoverView(frame: context.bounds)
        coverView.backgroundView.backgroundColor = Loader.configuration.backgroundColor
        let loaderView = Loader.configuration.loaderView()
        coverView.add(
            in: context,
            with: loaderView,
            animated: animated,
            completion: completion)
        return loaderView
    }
    
    @discardableResult
    public static func show<T: LoaderView>(in context: UIView?,
                                           of loaderType: T.Type,
                                           animated: Bool = true,
                                           completion: ((Bool) -> Void)? = nil) -> T? {
        guard self.loader(for: context).isNil else { return nil }
        guard let context: UIView = context else { return nil }
        let coverView = LoaderCoverView(frame: context.bounds)
        coverView.backgroundView.backgroundColor = Loader.configuration.backgroundColor
        let loaderView = loaderType.init()
        coverView.add(
            in: context,
            with: loaderView,
            animated: animated,
            completion: completion)
        return loaderView
    }
    
    @discardableResult
    public static func hide(in context: UIViewController?,
                            animated: Bool = true,
                            completion: ((Bool) -> Void)? = nil) -> LoaderView? {
        return self.hide(
            in: context?.view,
            animated: animated,
            completion: completion)
    }
    
    @discardableResult
    public static func hide(in context: UIView?,
                            animated: Bool = true,
                            completion: ((Bool) -> Void)? = nil) -> LoaderView? {
        guard let context: UIView = context else { return nil }
        let loaderView: LoaderView? = context.subviews
            .compactMap { $0 as? LoaderCoverView }
            .first?
            .loaderView
        loaderView?.hide(
            animated: animated,
            completion: { (status) in
                loaderView?.superview?.removeFromSuperview()
                completion?(status)
        })
        return loaderView
    }
    
    public static func loader(for context: UIViewController?) -> LoaderView? {
        return self.loader(for: context?.view)
    }
    
    public static func loader(for context: UIView?) -> LoaderView? {
        let coverView: LoaderCoverView? = context?.subviews
            .compactMap { $0 as? LoaderCoverView }
            .first
        return coverView?.loaderView
    }
}

// MARK: LoaderCoverView
public class LoaderCoverView: Component {
    public let backgroundView: UIView = UIView()
    public weak var loaderView: LoaderView?
    
    override public func setupView() {
        super.setupView()
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    public func add(in context: UIView,
                    with loaderView: LoaderView,
                    animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
        self.loaderView = loaderView
        loaderView.add(to: self)
        context.addSubview(self, with: [
            Anchor.to(context).fill
        ])
        self.layoutIfNeeded()
        loaderView.show(
            animated: animated,
            completion: completion)
    }
}

// MARK: LoaderView
open class LoaderView: Component {
    public var coverView: LoaderCoverView? {
        return self.superview as? LoaderCoverView
    }
    
    override public required init() {
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: HOOKS
    open func add(to parent: UIView) {
        // HOOK
    }
    
    open func show(animated: Bool,
                   completion: ((Bool) -> Void)?) {
        // HOOK
    }
    
    open func hide(animated: Bool,
                   completion: ((Bool) -> Void)?) {
        // HOOK
    }
}

// MARK: DefaultLoaderView
private class DefaultLoaderView: LoaderView {
    private let activityIndicatorView = Components.other.activityIndicator()
    
    required init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    override func add(to parent: UIView) {
        parent.addSubview(self, with: [
            Anchor.to(parent).center(80)
        ])
        self.addSubview(self.activityIndicatorView, with: [
            Anchor.to(self).center
        ])
    }
    
    override func show(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) {
        self.coverView?.backgroundView.alpha = 0
        self.animation(
            animated,
            duration: 0.3,
            animations: {
                self.coverView?.backgroundView.alpha = 1
                self.alpha = 1
        }, completion: completion)
    }
    
    override func hide(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) {
        self.animation(
            animated,
            duration: 0.3,
            animations: {
                self.coverView?.backgroundView.alpha = 0
                self.alpha = 0
        }, completion: completion)
    }
}
