//
//  InactiveCover.swift
//  Forms
//
//  Created by Konrad on 8/27/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import FormsUtils
import FormsUtilsUI
import UIKit

// MARK: InactiveCover
public class InactiveCover: AppLifecycleable {
    private var coverImage: LazyImage?
    private var coverView: LazyView?
    private var window: UIWindow?
    
    public var appLifecycleableEvents: [AppLifecycleEvent] {
        return [.didBecomeActive, .willResignActive]
    }
    
    public init(_ coverView: @escaping LazyView) {
        self.coverView = coverView
    }
    
    public init(_ coverImage: @escaping LazyImage) {
        self.coverImage = coverImage
    }
     
    public init() {
        self.coverImage = { [weak self] () in
            guard let `self` = self else { return nil }
            return self.screenCover()
        }
    }
    
    public func appLifecycleable(event: AppLifecycleEvent) {
        switch event {
        case .didBecomeActive:
            self.dismiss()
        case .willResignActive:
            self.present()
        default: break
        }
    }
    
    public func register() {
        self.registerAppLifecycle()
    }
    
    public func unregister() {
        self.unregisterAppLifecycle()
    }
    
    public func present(animated: Bool = true) {
        self.dismiss(animated: false)
        let window: UIWindow = UIWindow.new
        window.rootViewController = UIViewController()
        self.insertCover(into: window)
        window.setAlpha(
            alpha: 1.0,
            duration: 0.3,
            animated: animated)
        self.window = window
    }
    
    public func dismiss(animated: Bool = true) {
        guard let window: UIWindow = self.window else { return }
        window.setAlpha(
            alpha: 0.0,
            duration: 0.3,
            animated: animated,
            completion: { (_) in
                window.isHidden = true
                window.removeFromSuperview()
        })
    }
    
    private func screenCover() -> UIImage? {
        guard let window: UIWindow = UIApplication.shared.keyWindow else { return nil }
        UIGraphicsBeginImageContextWithOptions(window.frame.size, false, UIScreen.main.scale)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
        window.layer.render(in: context)
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
            .scaled(toFill: window.frame.size)
            .blured(radius: 8)
    }
    
    private func insertCover(into window: UIWindow) {
        if self.coverView.isNotNil {
            self.insertCoverView(into: window)
        } else if self.coverImage.isNotNil {
            self.insertCoverImage(into: window)
        }
    }
    
    private func insertCoverView(into window: UIWindow) {
        guard let view: UIView = self.coverView?() else { return }
        window.windowLevel = .statusBar
        window.addSubview(view, with: [
            Anchor.to(window).fill
        ])
        window.alpha = 0.0
        window.makeKeyAndVisible()
    }
    
    private func insertCoverImage(into window: UIWindow) {
        window.windowLevel = .statusBar
        let imageView: UIImageView = UIImageView()
        imageView.frame = window.bounds
        imageView.contentMode = .scaleToFill
        imageView.image = self.coverImage?()?
            .scaled(toFill: window.frame.size)
        window.addSubview(imageView, with: [
            Anchor.to(window).fill
        ])
        window.alpha = 0.0
        window.makeKeyAndVisible()
    }
}
