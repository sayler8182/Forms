//
//  FormsNavigationController.swift
//  Forms
//
//  Created by Konrad on 5/4/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsAnchor
import UIKit

// MARK: FormsNavigationController
open class FormsNavigationController: UINavigationController, Themeable {
    open var isThemeAutoRegister: Bool {
        return true
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.postInit()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.postInit()
    }
    
    override public init(nibName nibNameOrNil: String?,
                         bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.postInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.postInit()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    deinit {
        print("Deinit \(type(of: self))")
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.Colors.statusBar.style
    }
     
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    open func setupView() {
        self.setupConfiguration()
        self.setupTheme()
        
        // HOOKS
        self.setupNavigationBar()
        self.setupContent()
        self.setupActions()
        self.setupOther()
    }
    
    open func setTheme() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Theme.Colors.primaryText
        ]
        self.navigationBar.tintColor = Theme.Colors.primaryText
        self.navigationBar.barTintColor = Theme.Colors.primaryBackground
        self.view.backgroundColor = Theme.Colors.primaryBackground
    }
    
    // MARK: HOOKS
    open func postInit() {
        // HOOK
    }
    
    open func setupConfiguration() {
        // HOOK
    }
    
    open func setupTheme() {
        self.setTheme()
        guard self.isThemeAutoRegister else { return }
        Theme.register(self)
        // HOOK
    }
    
    open func setupNavigationBar() {
        // HOOK
    }
    
    open func setupContent() {
        // HOOK
    }
    
    open func setupActions() {
        // HOOK
    }
    
    open func setupOther() {
        // HOOK
    }
}

// MARK: ProgressBar
public extension FormsNavigationController {
    func setNavigationProgressBar(_ progressBar: ProgressBar) {
        self.navigationBar.progressBar?.removeFromSuperview()
        self.navigationBar.addSubview(progressBar, with: [
            Anchor.to(self.navigationBar).horizontal,
            Anchor.to(self.navigationBar).bottom.safeArea
        ])
    }
}

// MARK: UIViewController
public extension UIViewController {
    var embeded: UINavigationController {
        if let navigationController: UINavigationController = self.navigationController {
            return navigationController
        } else {
            return FormsNavigationController(rootViewController: self)
        }
    }
}

// MARK: UINavigationBar
public extension UINavigationBar {
    var progressBar: ProgressBar? {
        return self.subviews
            .compactMap { $0 as? ProgressBar }
            .first
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize: CGSize = super.sizeThatFits(size)
        if let progressBar: ProgressBar = self.progressBar {
            newSize.height += progressBar.height
        }
        return newSize
    }
}
