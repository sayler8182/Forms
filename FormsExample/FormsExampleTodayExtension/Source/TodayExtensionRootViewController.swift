//
//  TodayExtensionRootViewController.swift
//  FormsExampleTodayExtension
//
//  Created by Konrad on 9/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsInjector
import FormsTodayExtensionKit
import FormsUtils
import NotificationCenter
import UIKit

// MARK: TodayExtensionRootViewController
class TodayExtensionRootViewController: FormsTodayExtensionRootViewController {
    private let gradientView = Components.container.gradient()
        .with(gradientColors: [Theme.Colors.green, Theme.Colors.red])
        .with(height: 44)
    private let sharedLabel = Components.label.default()
        .with(alignment: .center)
        .with(numberOfLines: 0)
    private let navigateToAppButton = Components.button.default()
        .with(height: 44)
        .with(title: "Navigate to app!")
    private let writeSharedButton = Components.button.default()
        .with(height: 44)
        .with(title: "Write shared")
    
    @Injected
    private var sharedContainer: SharedContainerProtocol // swiftlint:disable:this let_var_whitespace
    
    override var compactHeight: CGFloat {
        return 44.0 + 16.0 + 44.0
    }
    
    override var expandedHeight: CGFloat {
        return self.compactHeight + 16.0 + 44.0 + 16.0 + 44.0
    }
    
    override func widgetPerformUpdate(completionHandler: @escaping ((NCUpdateResult) -> Void)) {
        self.readShared()
        completionHandler(.newData)
    }
    
    override func postInit() {
        self.root = TodayExtensionRoot.shared
        super.postInit()
    }
    
    override func setupContext(_ context: NSExtensionContext) {
        super.setupContext(context)
        self.setTheme()
        context.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func setupView() {
        super.setupView()
        self.readShared()
    }
    
    override func setupContent() {
        super.setupContent()
        self.contentView.addSubview(self.gradientView, with: [
            Anchor.to(self.contentView).top,
            Anchor.to(self.contentView).horizontal,
            Anchor.to(self.gradientView).height(44)
        ])
        self.contentView.addSubview(self.sharedLabel, with: [
            Anchor.to(self.gradientView).topToBottom.offset(16),
            Anchor.to(self.contentView).horizontal,
            Anchor.to(self.sharedLabel).height(44)
        ])
        self.contentView.addSubview(self.navigateToAppButton, with: [
            Anchor.to(self.sharedLabel).topToBottom.offset(16),
            Anchor.to(self.contentView).horizontal,
            Anchor.to(self.navigateToAppButton).height(44)
        ])
        self.contentView.addSubview(self.writeSharedButton, with: [
            Anchor.to(self.navigateToAppButton).topToBottom.offset(16),
            Anchor.to(self.contentView).horizontal,
            Anchor.to(self.writeSharedButton).height(44)
        ])
    }
    
    override func setupActions() {
        super.setupActions()
        self.navigateToAppButton.onClick = Unowned(self) { (_self) in
            _self.navigateToApp()
        }
        self.writeSharedButton.onClick = Unowned(self) { (_self) in
            _self.writeShared()
        }
    }
    
    private func navigateToApp() {
        guard let context: NSExtensionContext = self.extensionContext else { return }
        let coder: URLCoder = URLCoder()
        let url: URL = coder.encode(
            url: self.root.appURL,
            parameters: ["search_text": "SharedContainer"])
        context.open(url)
    }
    
    private func readShared() {
        let data: Data = self.sharedContainer.jsonData ?? Data()
        let string: String? = String(data: data, encoding: .utf8)
        guard string != self.sharedLabel.text else { return }
        self.sharedLabel.text = string
        self.update()
    }
    
    private func writeShared() {
        let data: Data = "Widget text".data
        self.sharedContainer.jsonData = self.sharedContainer.jsonData != data
            ? data
            : "Other widget text".data
        self.readShared()
    }
}
