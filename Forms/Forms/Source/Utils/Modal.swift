//
//  Modal.swift
//  Forms
//
//  Created by Konrad on 4/7/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import Injector
import UIKit

// MARK: Configuration
public protocol ConfigurationModalProtocol {
    var backgroundColor: UIColor? { get }
}

public extension Configuration {
    struct Modal: ConfigurationModalProtocol {
        public var backgroundColor: UIColor? = UIColor.black.withAlphaComponent(0.3)
    }
}

public protocol ModalKey {
    var rawValue: String { get }
}

// MARK: Modal
public enum Modal {
    @Injected
    public static var configuration: ConfigurationModalProtocol // swiftlint:disable:this let_var_whitespace
    
    @discardableResult
    public static func show<T: ModalView>(in context: UIViewController?,
                                          of modalType: T.Type,
                                          with key: ModalKey? = nil,
                                          animated: Bool = true,
                                          completion: ((Bool) -> Void)? = nil) -> T? {
        guard self.modal(for: context, of: modalType).isNil else { return nil }
        return self.show(
            in: context?.view,
            of: modalType,
            with: key,
            animated: animated,
            completion: completion)
    }
    
    @discardableResult
    public static func show<T: ModalView>(in context: UIView?,
                                          of modalType: T.Type,
                                          with key: ModalKey? = nil,
                                          animated: Bool = true,
                                          completion: ((Bool) -> Void)? = nil) -> T? {
        guard self.modal(for: context, of: modalType).isNil else { return nil }
        guard let context: UIView = context else { return nil }
        let coverView = ModalCoverView(frame: context.bounds)
        coverView.backgroundView.backgroundColor = Loader.configuration.backgroundColor
        let modalView = modalType.init()
        coverView.add(
            in: context,
            of: modalView,
            animated: animated,
            completion: completion)
        return modalView
    }
    
    @discardableResult
    public static func hide<T: ModalView>(in context: UIViewController?,
                                          of modalType: T.Type,
                                          with key: ModalKey? = nil,
                                          animated: Bool = true,
                                          completion: ((Bool) -> Void)? = nil) -> T? {
        return self.hide(
            in: context?.view,
            of: modalType,
            with: key,
            animated: animated,
            completion: completion)
    }
    
    @discardableResult
    public static func hide<T: ModalView>(in context: UIView?,
                                          of modalType: T.Type,
                                          with key: ModalKey? = nil,
                                          animated: Bool = true,
                                          completion: ((Bool) -> Void)? = nil) -> T? {
        guard let context: UIView = context else { return nil }
        let modalView: T? = context.subviews
            .map { $0 as? ModalCoverView }
            .filter { $0?.key?.rawValue == key?.rawValue }
            .compactMap { $0?.modalView as? T }
            .first
        modalView?.hide(
            animated: animated,
            completion: { (status) in
                modalView?.superview?.removeFromSuperview()
                completion?(status)
        })
        return modalView
    }
    
    public static func modal<T: ModalView>(for context: UIViewController?,
                                           with key: ModalKey? = nil,
                                           of modalType: T.Type) -> T? {
        return self.modal(
            for: context?.view,
            with: key,
            of: modalType)
    }
    
    public static func modal<T: ModalView>(for context: UIView?,
                                           with key: ModalKey? = nil,
                                           of modalType: T.Type) -> T? {
        let modalView: T? = context?.subviews
            .map { $0 as? ModalCoverView }
            .filter { $0?.key?.rawValue == key?.rawValue }
            .compactMap { $0?.modalView as? T }
            .first
        return modalView
    }
}

// MARK: ModalCoverView
public class ModalCoverView: FormComponent {
    public let backgroundView: UIView = UIView()
        .with(isUserInteractionEnabled: true)
    private let gestureRecognizer = UITapGestureRecognizer()
    
    public weak var modalView: ModalView? = nil
    public var key: ModalKey? = nil
    
    override public func setupView() {
        super.setupView()
        self.addSubview(self.backgroundView, with: [
            Anchor.to(self).fill
        ])
    }
    
    public func add(in context: UIView,
                    of modalView: ModalView,
                    with key: ModalKey? = nil,
                    animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
        self.modalView = modalView
        self.key = key
        modalView.add(to: self)
        context.addSubview(self, with: [
            Anchor.to(context).fill
        ])
        self.layoutIfNeeded()
        modalView.show(
            animated: animated,
            completion: completion)
    }
    
    override public func setupActions() {
        self.gestureRecognizer.addTarget(self, action: #selector(handleGesture))
        self.backgroundView.addGestureRecognizer(self.gestureRecognizer)
    }
    
    @objc
    private func handleGesture(recognizer: UITapGestureRecognizer) {
        guard let modalView = self.modalView else { return }
        guard modalView.isDismissable else { return }
        if let onDismiss = modalView.onDismiss {
            onDismiss(modalView)
        } else {
            modalView.hide(animated: true, completion: nil)
        }
    }
}

// MARK: ModalView
open class ModalView: FormComponent {
    public var isDismissable: Bool = true
    
    public var onDismiss: ((ModalView) -> Void)? = nil
    
    public var coverView: ModalCoverView? {
        return self.superview as? ModalCoverView
    }
    public var context: UIView? {
        return self.coverView?.superview
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
