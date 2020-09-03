//
//  FormsTodayExtensionRootViewController.swift
//  FormsTodayExtensionKit
//
//  Created by Konrad on 9/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsInjector
import UIKit

// MARK: FormsTodayExtensionRootViewController
open class FormsTodayExtensionRootViewController: FormsTodayExtensionViewController {
    open var root: FormsTodayExtensionRoot!
    
    override open func postInit() {
        super.postInit()
        self.root.configure()
        if #available(iOS 12.0, *) {
            Theme.setUserInterfaceStyle(self.traitCollection.userInterfaceStyle)
        }
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 12.0, *) {
            Theme.setUserInterfaceStyle(traitCollection.userInterfaceStyle)
        }
    }
}
