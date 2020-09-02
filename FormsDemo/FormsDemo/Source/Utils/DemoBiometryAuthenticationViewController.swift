//
//  DemoBiometryAuthenticationViewController.swift
//  FormsDemo
//
//  Created by Konrad on 9/2/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsInjector
import FormsUtils
import UIKit

// MARK: DemoBiometryAuthenticationViewController
class DemoBiometryAuthenticationViewController: FormsTableViewController {
    private let authenticationButton = Components.button.default()
        .with(title: "Authentication")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    @Injected
    private var biometryAuthentication: BiometryAuthenticationProtocol // swiftlint:disable:this let_var_whitespace
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.authenticationButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.authenticationButton.onClick = Unowned(self) { (_self) in
            _self.authentication()
        }
    }
    
    private func authentication() {
        self.biometryAuthentication.evaluate(
            policy: .deviceOwnerAuthenticationWithBiometrics,
            reason: "Identify yourself",
            onSuccess: { [weak self] in
                guard let `self` = self else { return }
                UIAlertController(preferredStyle: .alert)
                    .with(message: "Biometry Authentication with success")
                    .with(title: "Success")
                    .with(action: "Ok")
                    .present(on: self)
            }, onError: { [weak self] (error) in
                guard let `self` = self else { return }
                UIAlertController(preferredStyle: .alert)
                    .with(message: error.localizedDescription)
                    .with(title: "Error")
                    .with(action: "Ok")
                    .present(on: self)
        })
    }
}
