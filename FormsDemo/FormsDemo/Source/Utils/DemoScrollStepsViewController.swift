//
//  DemoScrollStepsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import UIKit

// MARK: DemoScrollStepsViewController
class DemoScrollStepsViewController: FormsViewController {
    private let topView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
    private lazy var scrollView = Components.container.scroll()
        .with(items: [self.scrollContentView])
        .with(scrollDirection: .vertical)
        .with(scrollSteps: self.scrollSteps)
        .with(showsVerticalScrollIndicator: true)
    private let scrollContentView = Components.container.view()
        .with(anchors: { [Anchor.to($0).height(4_000)] })
        .with(backgroundColor: Theme.Colors.secondaryBackground)
    private let bottomView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)

    private let topViewTopAnchor = AnchorConnection()
    private let bottomViewBottomAnchor = AnchorConnection()
    
    private lazy var scrollSteps = ScrollSteps([self.scrollTopSteps, self.scrollBottomSteps])
    private let scrollTopSteps = ScrollStep(0..<200)
    private let scrollBottomSteps = ScrollStep(200..<800)
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.topView, with: [
            Anchor.to(self.view).top.safeArea.connect(self.topViewTopAnchor),
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).height(180.0)
        ])
        self.view.addSubview(self.scrollView, with: [
            Anchor.to(self.view).top.safeArea,
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom,
            Anchor.to(self.scrollContentView).width
        ])
        self.view.addSubview(self.bottomView, with: [
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom.connect(self.bottomViewBottomAnchor),
            Anchor.to(self.view).height(100.0)
        ])
        self.view.sendSubviewToBack(self.scrollView)
    }
    
    override func setupActions() {
        super.setupActions() 
        self.scrollSteps.onUpdateVertical = { [unowned self] (step, progress) in
            switch step {
            case self.scrollTopSteps:
                self.topViewTopAnchor.constant = -self.topView.realHeight * progress
                self.topView.isHidden = progress.floored.asBool
            case self.scrollBottomSteps:
                self.bottomViewBottomAnchor.constant = self.bottomView.realHeight * progress
                self.bottomView.isHidden = progress.floored.asBool
            default: break
            }
        }
    }
}
