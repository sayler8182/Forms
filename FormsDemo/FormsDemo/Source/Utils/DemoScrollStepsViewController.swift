//
//  DemoScrollStepsViewController.swift
//  FormsDemo
//
//  Created by Konrad on 5/13/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import FormsUtilsUI
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
        .with(backgroundColor: Theme.Colors.secondaryLight)
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
        self.scrollSteps.onUpdateVertical = Unowned(self) { (_self, step, progress) in
            switch step {
            case _self.scrollTopSteps:
                _self.topViewTopAnchor.constant = -_self.topView.realHeight * progress
                _self.topView.isHidden = progress.floored.asBool
            case _self.scrollBottomSteps:
                _self.bottomViewBottomAnchor.constant = _self.bottomView.realHeight * progress
                _self.bottomView.isHidden = progress.floored.asBool
            default: break
            }
        }
    }
}
