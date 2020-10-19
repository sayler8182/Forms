//
//  SnapshotViewAnimator.swift
//  FormsTransitions
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: SnapshotViewMatch
public class SnapshotViewMatch: ViewMatch {
    public let fromAlpha: CGFloat
    public let toAlpha: CGFloat
    
    private lazy var transitionFromView: UIView = {
        let image: UIImage? = self.fromView.snapshotImage()
        let view = UIImageView(image: image)
        view.contentMode = self.fromView.viewContentMode
        return view
    }()
    private lazy var transitionToView: UIView = {
        let image: UIImage? = self.toView.snapshotImage()
        let view = UIImageView(image: image)
        view.contentMode = self.toView.viewContentMode
        return view
    }()
    
    private var leaveRootInSource: Bool {
        return self.fromView.viewOptions.contains(.leaveRootInSource) || self.fromView.viewOptions.contains(.leaveRoot)
    }
    private var leaveRootInDestination: Bool {
        return self.toView.viewOptions.contains(.leaveRootInDestination) || self.toView.viewOptions.contains(.leaveRoot)
    }
    private var leaveRoot: Bool {
        return self.fromView.viewOptions.contains(.leaveRoot) || self.toView.viewOptions.contains(.leaveRoot)
    }
    private var skipInSource: Bool {
        return self.fromView.viewOptions.contains(.skipInSource) || self.fromView.viewOptions.contains(.skip)
    }
    private var skipInDestination: Bool {
        return self.toView.viewOptions.contains(.skipInDestination) || self.toView.viewOptions.contains(.skip)
    }
    private var skip: Bool {
        return self.fromView.viewOptions.contains(.skip) || self.toView.viewOptions.contains(.skip)
    }
    private var moveSource: Bool {
        return self.fromView.viewOptions.contains(.moveSource)
    }
    private var moveDestination: Bool {
        return self.toView.viewOptions.contains(.moveDestination)
    }
    
    public required init(fromView: UIView,
                         fromFrame: CGRect,
                         toView: UIView,
                         toFrame: CGRect) {
        self.fromAlpha = fromView.alpha
        self.toAlpha = toView.alpha
        
        super.init(
            fromView: fromView,
            fromFrame: fromFrame,
            toView: toView,
            toFrame: toFrame)
    }
    
    override public func beginTransition(in container: UIView) {
        if !self.skipInSource && !self.moveDestination {
            self.transitionFromView.alpha = self.fromAlpha
            self.transitionFromView.frame = self.fromFrame
            container.addSubview(self.transitionFromView)
        }
        if !self.skipInDestination && !self.moveSource {
            self.transitionToView.alpha = self.moveDestination ? self.toAlpha : 0
            self.transitionToView.frame = self.fromFrame
            container.addSubview(self.transitionToView)
        }
        if !self.leaveRootInSource {
            self.fromView.alpha = 0
        }
        if !self.leaveRootInDestination {
            self.toView.alpha = 0
        }
    }
    
    override public func updateTransition(in container: UIView) {
        if !self.skipInSource {
            if !self.moveSource {
                self.transitionFromView.alpha = 0
            }
            self.transitionFromView.frame = self.toFrame
        }
        if !self.skipInDestination {
            if !self.moveDestination {
                self.transitionToView.alpha = self.toAlpha
            }
            self.transitionToView.frame = self.toFrame
        }
    }
    
    override public func endTransition(in container: UIView) {
        if !self.leaveRootInSource {
            self.fromView.alpha = self.fromAlpha
        }
        if !self.leaveRootInDestination {
            self.toView.alpha = self.toAlpha
        }
        if !self.skipInSource && !self.moveDestination {
            self.transitionFromView.removeFromSuperview()
        }
        if !self.skipInDestination && !self.moveSource {
            self.transitionToView.removeFromSuperview()
        }
    }
}

// MARK: SnapshotViewAnimator
public class SnapshotViewAnimator: ViewAnimator {
    override public var matchesType: ViewMatch.Type {
        return SnapshotViewMatch.self
    }
}
