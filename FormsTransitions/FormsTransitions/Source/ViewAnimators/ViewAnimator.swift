//
//  ViewAnimator.swift
//  FormsTransitions
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: ViewMatch
public class ViewMatch {
    public let fromView: UIView
    public let fromFrame: CGRect
    public let toView: UIView
    public let toFrame: CGRect
    
    public required init(fromView: UIView,
                         fromFrame: CGRect,
                         toView: UIView,
                         toFrame: CGRect) {
        self.fromView = fromView
        self.fromFrame = fromFrame
        self.toView = toView
        self.toFrame = toFrame
    }
    
    // HOOKS
    public func beginTransition(in container: UIView) {
        // HOOK
    }
    
    public func updateTransition(in container: UIView) {
        // HOOK
    }
        
    public func endTransition(in container: UIView) {
        // HOOK
    }
}

// MARK: ViewAnimator
public class ViewAnimator {
    public let isDynamic: Bool
    public let container: UIView
    public let fromView: UIView
    public let toView: UIView
    public let transitionContainer: UIView = UIView()
    
    public var matchesType: ViewMatch.Type {
        return ViewMatch.self
    }
    
    private var _fromViews: [UIView]? = nil
    public var fromViews: [UIView] {
        if let fromViews: [UIView] = self._fromViews { return fromViews }
        let fromViews = self.animatedSubviews(in: self.fromView)
        self._fromViews = fromViews
        return fromViews
    }
    private var _toViews: [UIView]? = nil
    public var toViews: [UIView] {
        if let toViews: [UIView] = self._toViews { return toViews }
        let toViews = self.animatedSubviews(in: self.toView)
        self._toViews = toViews
        return toViews
    }
    private var _matches: [ViewMatch]? = nil
    public var matches: [ViewMatch] {
        if let matches: [ViewMatch] = self._matches { return matches }
        let matches = self.createMatches(of: self.matchesType)
        self._matches = matches
        return matches
    }
    
    public init(isDynamic: Bool,
                container: UIView,
                fromView: UIView,
                toView: UIView) {
        self.isDynamic = isDynamic
        self.container = container
        self.fromView = fromView
        self.toView = toView
    }
    
    public func beginTransition() {
        self.transitionContainer.frame = self.container.bounds
        self.container.addSubview(self.transitionContainer)
        self.matches.forEach {
            $0.beginTransition(in: self.transitionContainer)
        }
    }
    
    public func updateTransition() {
        self.transitionContainer.frame = self.container.bounds
        self.matches.forEach {
            $0.updateTransition(in: self.container)
        }
    }
    
    public func endTransition() {
        self.transitionContainer.removeFromSuperview()
        self.matches.forEach {
            $0.endTransition(in: self.container)
        }
        self.reset()
    }
    
    internal func createMatches<T: ViewMatch>(of type: T.Type) -> [T] {
        var matches: [T] = []
        let fromViews: [UIView] = self.fromViews
        let toViews: [UIView] = self.toViews
        for fromView in fromViews {
            guard let toView: UIView = toViews.first(where: { $0.viewKey == fromView.viewKey }) else { continue }
            let fromFrame: CGRect = self.frame(for: fromView, in: self.fromView)
            let toFrame: CGRect = self.frame(for: toView, in: self.toView)
            let match: T = type.init(
                fromView: fromView,
                fromFrame: fromFrame,
                toView: toView,
                toFrame: toFrame)
            matches.append(match)
        }
        return matches
    }
    
    internal func whenDynamic(_ action: () -> Void) {
        guard self.isDynamic else { return }
        action()
    }
    
    private func animatedSubviews(in view: UIView) -> [UIView] {
        var views: [UIView] = []
        if view.viewKey != nil {
            views.append(view)
        }
        let subviews: [UIView] = view.subviews
            .flatMap { self.animatedSubviews(in: $0) }
        views.append(contentsOf: subviews)
        return views
    }
    
    private func frame(for view: UIView, in source: UIView) -> CGRect {
        var rect: CGRect = view.convert(view.bounds, to: source.superview)
        let yDiff: CGFloat = source.frame.height - source.superview.or(source).frame.height
        let xDiff: CGFloat = source.frame.width - source.superview.or(source).frame.width
        rect.origin.y = view.convert(view.bounds, to: source).origin.y - yDiff
        rect.origin.x = view.convert(view.bounds, to: source).origin.x - xDiff
        return rect
    }
    
    private func reset() {
        self._fromViews = []
        self._toViews = []
        self._matches = []
    }
}
