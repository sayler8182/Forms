//
//  Keyboard.swift
//  Forms
//
//  Created by Konrad on 5/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public class Keyboard: NSObject {
    public typealias OnUpdate = (_ percent: CGFloat, _ visibleHeight: CGFloat, _ animated: Bool) -> Void
    
    private weak var keyboardView: UIView? = nil
    private var displayLink: CADisplayLink? = nil
    private var frame: CGRect? = nil
    
    public var onUpdate: OnUpdate? = nil
    
    deinit {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }
    
    public func register() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShowForResizing),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHideForResizing),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShowForResizing),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHideForResizing),
            name: UIResponder.keyboardDidHideNotification,
            object: nil)
    }
    
    public func unregister() {
        self.stopObserver()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func extractKeyboardView() -> UIView? {
        return UIApplication.shared.windows.reversed()
            .first(where: { type(of: $0) == NSClassFromString("UITextEffectsWindow") })?
            .flatSubviews
            .first(where: { type(of: $0) == NSClassFromString("UIInputSetHostView") })
    }
    
    private func runObserver() {
        self.displayLink?.invalidate()
        let displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink))
        displayLink.add(to: RunLoop.main, forMode: .common)
        self.displayLink = displayLink
    }
    
    private func stopObserver() {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }
    
    @objc
    private func handleDisplayLink() {
        self.updateKeyboardFrame()
    }
    
    private func updateKeyboardFrame() {
        guard let keyboardView: UIView = self.keyboardView else { return }
        guard self.frame != keyboardView.frame else { return }
        guard keyboardView.frame.height != 0 else { return }
        self.frame = keyboardView.frame
        let keyboardHeight: CGFloat = keyboardView.frame.height
        let keyboardOriginY: CGFloat = keyboardView.frame.origin.y
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let percent: CGFloat = ((keyboardOriginY - (screenHeight - keyboardHeight)) / keyboardHeight).reversed(progress: 1.0)
        let visibleHeight: CGFloat = percent * keyboardHeight
        self.onUpdate?(percent, visibleHeight, false)
    }
    
    @objc
    private func keyboardWillShowForResizing(notification: Notification) {
        let keyboardFrame: NSValue? = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardHeight: CGFloat = keyboardFrame?.cgRectValue.height else { return }
        self.onUpdate?(1.0, keyboardHeight, true)
    }
    
    @objc
    private func keyboardWillHideForResizing(notification: Notification) {
        self.onUpdate?(0.0, 0.0, true)
    }
    
    @objc
    private func keyboardDidShowForResizing(notification: Notification) {
        self.keyboardView = self.extractKeyboardView()
        self.runObserver()
    }
    
    @objc
    private func keyboardDidHideForResizing(notification: Notification) {
        self.stopObserver()
        self.keyboardView = nil
        self.frame = nil
    }
}
