//
//  ViewAnimator.swift
//  Transition
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: ViewMatch
public class ViewMatch {
    public let fromView: UIView
    public let toView: UIView
    
    public required init(fromView: UIView,
                         toView: UIView) {
        self.fromView = fromView
        self.toView = toView
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
    public let container: UIView
    public let fromView: UIView
    public let toView: UIView
    
    public var matchesType: ViewMatch.Type {
        return ViewMatch.self
    }
    
    public lazy var fromViews: [UIView] = {
        return self.animatedSubviews(in: self.fromView)
    }()
    public lazy var toViews: [UIView] = {
        return self.animatedSubviews(in: self.toView)
    }()
    public lazy var matches: [ViewMatch] = {
        return self.createMatches(of: self.matchesType)
    }()
    
    public init(container: UIView,
                fromView: UIView,
                toView: UIView) {
        self.container = container
        self.fromView = fromView
        self.toView = toView
    }
    
    public func beginTransition() {
        self.matches.forEach {
            $0.beginTransition(in: self.container)
        }
    }
    
    public func updateTransition() {
        self.matches.forEach {
            $0.updateTransition(in: self.container)
        }
    }
    
    public func endTransition() {
        self.matches.forEach {
            $0.endTransition(in: self.container)
        }
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
    
    internal func createMatches<T: ViewMatch>(of type: T.Type) -> [T] {
        var matches: [T] = []
        let fromViews: [UIView] = self.fromViews
        let toViews: [UIView] = self.toViews
        for fromView in fromViews {
            guard let toView: UIView = toViews.first(where: { $0.viewKey == fromView.viewKey }) else { continue }
            let match: T = type.init(
                fromView: fromView,
                toView: toView)
            matches.append(match)
        }
        return matches
    }
}
