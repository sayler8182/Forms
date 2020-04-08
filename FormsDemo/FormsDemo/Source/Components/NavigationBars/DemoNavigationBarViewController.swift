//
//  DemoNavigationBarViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoNavigationBarViewController
class DemoNavigationBarViewController: TableViewController {
    private lazy var defaultNavigationBar = Components.navigationBar.navigationBar()
        .with(title: "Default navigation bar")
    private lazy var navigationBarWithoutBack = Components.navigationBar.navigationBar()
        .with(isBack: false)
        .with(title: "Navigation bar without back")
    private lazy var navigationBarWithLeftAndRightBar = Components.navigationBar.navigationBar()
        .with(leftBarButtonItems: [self.text1BarItem])
        .with(rightBarButtonItems: [self.image1BarItem])
        .with(title: "Navigation bar with left and left bar")
    private lazy var navigationBarWithLeftAndRightBars = Components.navigationBar.navigationBar()
        .with(backgroundColor: UIColor.lightGray)
        .with(leftBarButtonItems: [self.text1BarItem, self.text2BarItem])
        .with(rightBarButtonItems: [self.image1BarItem, self.image2BarItem])
        .with(tintColor: UIColor.red)
        .with(title: "Navigation bar with left and left bars")
    private lazy var navigationBarWithTitleView = Components.navigationBar.navigationBar()
        .with(isBack: false)
        .with(titleView: self.navigationBarTitleView)
    private lazy var navigationBarWithoutShadow = Components.navigationBar.navigationBar()
        .with(isShadow: false)
        .with(title: "Navigation bar without shadow") 
    
    private let defaultNavigationBarButton = Components.button.primary()
        .with(title: "Default navigation bar")
    private let navigationBarWithoutBackButton = Components.button.primary()
        .with(title: "Navigation bar without back")
    private let navigationBarWithLeftAndRightBarButton = Components.button.primary()
        .with(title: "Navigation bar with left and left bar")
    private let navigationBarWithLeftAndRightBarsButton = Components.button.primary()
        .with(title: "Navigation bar with left and left bars")
    private var navigationBarWithTitleViewButton = Components.button.primary()
        .with(title: "Navigation bar with title view")
    private var navigationBarWithoutShadowButton = Components.button.primary()
        .with(title: "Navigation bar without shadow")
    
    private lazy var text1BarItem = BarItem()
        .with(title: "Item 1")
    private lazy var text2BarItem = BarItem()
        .with(title: "Item 2")
    private lazy var image1BarItem = BarItem()
        .with(imageSystemName: "heart.fill")
    private lazy var image2BarItem = BarItem()
        .with(imageSystemName: "square.and.arrow.up")
    
    private lazy var navigationBarTitleView = UIView()
        .with(backgroundColor: UIColor.red)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.setNavigationBar(self.defaultNavigationBar)
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.divider,
            self.defaultNavigationBarButton,
            self.navigationBarWithoutBackButton,
            self.navigationBarWithLeftAndRightBarButton,
            self.navigationBarWithLeftAndRightBarsButton,
            self.navigationBarWithTitleViewButton,
            self.navigationBarWithoutShadowButton
        ], divider: self.divider)
        
        self.navigationBarTitleView.anchors([
            Anchor.to(self.navigationBarTitleView).height(12).width(100)
        ])
    }
    
    override func setupActions() {
        super.setupActions()
        let map: [Button: NavigationBar] = [
            self.defaultNavigationBarButton: self.defaultNavigationBar,
            self.navigationBarWithoutBackButton: self.navigationBarWithoutBack,
            self.navigationBarWithLeftAndRightBarButton: self.navigationBarWithLeftAndRightBar,
            self.navigationBarWithLeftAndRightBarsButton: self.navigationBarWithLeftAndRightBars,
            self.navigationBarWithTitleViewButton: self.navigationBarWithTitleView,
            self.navigationBarWithoutShadowButton: self.navigationBarWithoutShadow
        ]
        for item in map {
            item.key.onClick = { [unowned self] in
                self.setNavigationBar(item.value)
            }
        }
    }
}
