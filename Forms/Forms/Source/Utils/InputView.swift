//
//  InputView.swift
//  Forms
//
//  Created by Konrad on 8/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtils
import FormsUtilsUI
import UIKit

// MARK: AssociatedKeys
private enum AssociatedKeys {
    static var inputViewKey: UInt8 = 0
    static var inputAccessoryViewKey: UInt8 = 0
}

// MARK: InputViewable
public protocol InputViewable: class, Inputable {
    var inputableView: UIView? { get set }
    var inputableAccessoryView: UIView? { get set }
}

public extension InputViewable {
    private var _inputView: InputView? {
        get { return getObject(self, &AssociatedKeys.inputViewKey) }
        set { setObject(self, &AssociatedKeys.inputViewKey, newValue) }
    }
    private var _inputAccessoryView: InputAccessoryView? {
        get { return getObject(self, &AssociatedKeys.inputAccessoryViewKey) }
        set { setObject(self, &AssociatedKeys.inputAccessoryViewKey, newValue) }
    }
    
    func setInputView(input inputView: InputView?) {
        inputView?.inputableView = self
        self._inputView = inputView
        self.inputableView = inputView?.view
    }
    
    func setInputView(accessory inputAccessoryView: InputAccessoryView?) {
        inputAccessoryView?.inputableView = self
        self._inputAccessoryView = inputAccessoryView
        self.inputableAccessoryView = inputAccessoryView?.view
    }
    
    func setInputView(input inputView: InputView?,
                      accessory inputAccessoryView: InputAccessoryView?) {
        self.setInputView(input: inputView)
        self.setInputView(accessory: inputAccessoryView)
    }
    
    func removeInputView() {
        self.setInputView(input: nil)
        self.setInputView(accessory: nil)
    }
}

// MARK: InputView
public class InputView {
    fileprivate weak var inputableView: InputViewable?
    fileprivate var view: UIView?
    
    public init(_ view: UIInputView) {
        self.view = view
    }
    
    public init(_ view: UIView) {
        self.view = InputViewWrapper(view)
    }
}

// MARK: InputAccessoryView
public class InputAccessoryView {
    fileprivate weak var inputableView: InputViewable?
    fileprivate var view: UIView?
    
    public init(_ view: UIView) {
        self.view = view
    }
}

// MARK: ToolbarAccessoryView
public class ToolbarAccessoryView: InputAccessoryView {
    override var inputableView: InputViewable? {
        get { return super.inputableView }
        set {
            super.inputableView = newValue
            self.toolbar?.inputableView = newValue
        }
    }
    
    private var toolbar: InputAccessoryToolbar? {
        return self.view as? InputAccessoryToolbar
    }
    
    public init(_ items: [UIBarButtonItem]) {
        let toolbar: InputAccessoryToolbar = InputAccessoryToolbar(items)
        super.init(toolbar)
    }
}

// MARK: InputAccessoryToolbar
public class InputAccessoryToolbar: UIToolbar, UIBarButtonItemFocusable {
    public weak var inputableView: InputViewable?
    
    public func lostFocus() {
        self.inputableView?.lostFocus()
    }
}

// MARK: InputViewWrapper
private class InputViewWrapper: UIInputView {
    override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
    }
    
    convenience init(_ contentView: UIView) {
        self.init(frame: CGRect(width: 320, height: 44))
        self.allowsSelfSizing = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView, with: [
            Anchor.to(self).top,
            Anchor.to(self).horizontal,
            Anchor.to(self).bottom.priority(.defaultHigh)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
