//
//  FormsTodayExtensionViewController.swift
//  FormsTodayExtensionKit
//
//  Created by Konrad on 9/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import NotificationCenter
import UIKit

// MARK: TodayExtensionViewController
open class FormsTodayExtensionViewController: UIViewController, NCWidgetProviding, Themeable {
    public var contentView: UIView = UIView()
        .with(backgroundColor: UIColor.clear)
    
    open var isThemeAutoRegister: Bool {
        return true
    }
    
    public private (set) var activeDisplayMode: NCWidgetDisplayMode = .compact
    
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
    
    open func setupView() {
        self.setupConfiguration()
        self.setupTheme()
        
        // HOOKS
        self.setupContent()
        self.setupActions()
        self.setupOther()
        self.setupMock()
        
        if let context: NSExtensionContext = self.extensionContext {
            self.setupContext(context)
        }
    }
    
    open func setTheme() {
        self.view.backgroundColor = Theme.Colors.clear
        self.view.flatSubviews
            .compactMap { $0 as? Themeable }
            .forEach { $0.setTheme() }
    }
    
    // MARK: HOOKS
    open func postInit() {
        // HOOK
    }
    
    open func setupConfiguration() {
        // HOOK
    }
    
    open func setupContext(_ context: NSExtensionContext) {
        // HOOK
    }
    
    open func setupTheme() {
        self.setTheme()
        guard self.isThemeAutoRegister else { return }
        Theme.register(self)
        // HOOK
    }
    
    open func setupContent() {
        self.view.addSubview(self.contentView, with: [
            Anchor.to(self.view).top,
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom.priority(.almostRequired)
        ])
        // HOOK
    }
    
    open func setupActions() {
        // HOOK
    }
    
    open func setupOther() {
        // HOOK
    }
    
    @objc
    open dynamic func setupMock() {
        // HOOK
    }
    
    // MARK: Widget
    open var compactHeight: CGFloat {
        return 44.0 * 3
    }
    open var expandedHeight: CGFloat {
        return 44.0 * 3 * 2
    }
    
    open func update() {
        self.widgetPerformUpdate { _ in }
    }
    
    open func widgetPerformUpdate(completionHandler: @escaping ((NCUpdateResult) -> Void)) {
        completionHandler(.noData)
    }
    
    open func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode,
                                               withMaximumSize maxSize: CGSize) {
        self.activeDisplayMode = activeDisplayMode
        let width: CGFloat = self.view.frame.width
        switch activeDisplayMode {
        case .compact:
            self.preferredContentSize = CGSize(width: width, height: self.compactHeight)
        case .expanded:
            self.preferredContentSize = CGSize(width: width, height: self.expandedHeight)
        @unknown default: break
        }
    }
}
