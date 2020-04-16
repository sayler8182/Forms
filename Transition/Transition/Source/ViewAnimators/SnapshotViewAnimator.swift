//
//  SnapshotViewAnimator.swift
//  Transition
//
//  Created by Konrad on 4/16/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: SnapshotViewMatch
public class SnapshotViewMatch: ViewMatch {
    public let fromAlpha: CGFloat
    public let fromFrame: CGRect
    public let toAlpha: CGFloat
    public let toFrame: CGRect
    
    private lazy var transitionFromView: UIView = {
        let image: UIImage? = self.fromView.snapshotImage()
        let view = UIImageView(image: image)
        return view
    }()
    private lazy var transitionToView: UIView = {
        let image: UIImage? = self.toView.snapshotImage()
        let view = UIImageView(image: image)
        return view
    }()
    
    public required init(fromView: UIView,
                         toView: UIView) {
        self.fromAlpha = fromView.alpha
        self.fromFrame = fromView.frame
        self.toAlpha = toView.alpha
        self.toFrame = toView.frame
        
        super.init(
            fromView: fromView,
            toView: toView)
    }
    
    override public func beginTransition(in container: UIView) {
        self.transitionFromView.alpha = self.fromAlpha
        self.transitionFromView.frame = self.fromFrame
        container.addSubview(self.transitionFromView)
        self.transitionToView.alpha = 0
        self.transitionToView.frame = self.fromFrame
        container.addSubview(self.transitionToView)
        self.fromView.alpha = 0
        self.toView.alpha = 0
    }
    
    override public func updateTransition(in container: UIView) {
        self.transitionFromView.alpha = 0
        self.transitionFromView.frame = self.toFrame
        self.transitionToView.alpha = self.toAlpha
        self.transitionToView.frame = self.toFrame
    }
    
    override public func endTransition(in container: UIView) {
        self.fromView.alpha = self.fromAlpha
        self.toView.alpha = self.toAlpha
        self.transitionFromView.removeFromSuperview()
        self.transitionToView.removeFromSuperview()
    }
}

// MARK: SnapshotViewAnimator
public class SnapshotViewAnimator: ViewAnimator {
    override public var matchesType: ViewMatch.Type {
        return SnapshotViewMatch.self
    }
}
