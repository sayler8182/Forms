//
//  DemoNavigationBarViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsUtils
import FormsUtilsUI
import UIKit

// MARK: DemoNavigationBarViewController
class DemoNavigationBarViewController: FormsTableViewController {
    private lazy var defaultNavigationBar = Components.navigationBar.default()
        .with(title: "Default navigation bar")
    private lazy var navigationBarWithoutBack = Components.navigationBar.default()
        .with(isBack: false)
        .with(title: "Navigation bar without back")
    private lazy var navigationBarWithLeftAndRightBar = Components.navigationBar.default()
        .with(leftBarButtonItems: [self.text1BarButtonItem])
        .with(rightBarButtonItems: [self.image1BarButtonItem])
        .with(title: "Navigation bar with left and left bar")
    private lazy var navigationBarWithLeftAndRightBars = Components.navigationBar.default()
        .with(backgroundColor: Theme.Colors.gray)
        .with(leftBarButtonItems: [self.text1BarButtonItem, self.text2BarButtonItem])
        .with(rightBarButtonItems: [self.image1BarButtonItem, self.image2BarButtonItem])
        .with(tintColor: Theme.Colors.red)
        .with(title: "Navigation bar with left and left bars")
    private lazy var navigationBarWithTitleView = Components.navigationBar.default()
        .with(isBack: false)
        .with(titleView: self.navigationBarTitleView)
    private lazy var navigationBarWithoutShadow = Components.navigationBar.default()
        .with(isShadow: false)
        .with(title: "Navigation bar without shadow") 
    private lazy var navigationBarWithSearchBar = Components.navigationBar.default()
        .with(titleView: self.navigationBarSearchBar)
        .with(rightBarButtonItems: [self.cancelBarButtonItem])
    
    private let defaultNavigationBarButton = Components.button.default()
        .with(title: "Default navigation bar")
    private let navigationBarWithoutBackButton = Components.button.default()
        .with(title: "Navigation bar without back")
    private let navigationBarWithLeftAndRightBarButton = Components.button.default()
        .with(title: "Navigation bar with left and left bar")
    private let navigationBarWithLeftAndRightBarsButton = Components.button.default()
        .with(title: "Navigation bar with left and left bars")
    private var navigationBarWithTitleViewButton = Components.button.default()
        .with(title: "Navigation bar with title view")
    private var navigationBarWithoutShadowButton = Components.button.default()
        .with(title: "Navigation bar without shadow")
    private var navigationBarWithSearchBarButton = Components.button.default()
        .with(title: "Navigation bar with search bar")
    
    private lazy var text1BarButtonItem = BarButtonItem()
        .with(title: "Item 1")
    private lazy var text2BarButtonItem = BarButtonItem()
        .with(title: "Item 2")
    private lazy var image1BarButtonItem = BarButtonItem()
        .with(imageName: "heart.fill")
    private lazy var image2BarButtonItem = BarButtonItem()
        .with(imageName: "square.and.arrow.up")
    private lazy var cancelBarButtonItem = BarButtonItem()
        .with(title: "Cancel")
    
    private lazy var navigationBarTitleView = Components.container.view()
        .with(backgroundColor: Theme.Colors.red)
    private lazy var navigationBarSearchBar = Components.input.searchBar.default()
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavigationBar(self.defaultNavigationBar)
    }
    
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
            self.navigationBarWithoutShadowButton,
            self.navigationBarWithSearchBarButton
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
            self.navigationBarWithoutShadowButton: self.navigationBarWithoutShadow,
            self.navigationBarWithSearchBarButton: self.navigationBarWithSearchBar
        ]
        for item in map {
            item.key.onClick = Unowned(self) { (_self) in
                _self.setNavigationBar(item.value)
            }
        }
        self.cancelBarButtonItem.onClick = Unowned(self) { (_self) in
            _self.navigationBarSearchBar.endEditing(true)
        }
    }
}
