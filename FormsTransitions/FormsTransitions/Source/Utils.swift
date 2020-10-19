//
//  Utils.swift
//  FormsTransitions
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsUtils
import UIKit

// MARK: TransitionOption
public enum TransitionOption: Equatable {
    case leaveRootInSource
    case leaveRootInDestination
    case leaveRoot
    case skipInSource
    case skipInDestination
    case skip
    case moveSource
    case moveDestination
    case forceMatch
}

// MARK: UIView
public extension UIView {
    private static var viewKey: UInt8 = 0
    private static var viewOptions: UInt8 = 0
    private static var viewContentMode: UInt8 = 0
    private static var viewIsCustomSnapshot: UInt8 = 0
    
    var viewKey: String? {
        get { return getObject(self, &Self.viewKey) }
        set { setObject(self, &Self.viewKey, newValue) }
    }
    var viewOptions: [TransitionOption] {
        get { return getObject(self, &Self.viewOptions) ?? [] }
        set { setObject(self, &Self.viewOptions, newValue) }
    }
    var viewContentMode: UIView.ContentMode {
        get { return getObject(self, &Self.viewContentMode) ?? .scaleToFill }
        set { setObject(self, &Self.viewContentMode, newValue) }
    }
    internal var viewIsCustomSnapshot: Bool {
        get { return getObject(self, &Self.viewIsCustomSnapshot) ?? false }
        set { setObject(self, &Self.viewIsCustomSnapshot, newValue) }
    }
    
    func with(viewKey: String) -> Self {
        self.viewKey = viewKey
        return self
    }
    func with(viewOptions: [TransitionOption]) -> Self {
        self.viewOptions = viewOptions
        return self
    }
    func with(viewContentMode: UIView.ContentMode) -> Self {
        self.viewContentMode = viewContentMode
        return self
    }
}

// MARK: CustomTransitionView
public protocol CustomSnapshotView {
    var customSnapshot: UIView { get }
}

// MARK: UIView
internal extension UIView {
    func snapshotImage() -> UIImage? {
        let view: UIView = self
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: currentContext)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}
