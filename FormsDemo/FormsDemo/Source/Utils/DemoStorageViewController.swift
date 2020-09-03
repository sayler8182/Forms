//
//  DemoStorageViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsUtils
import UIKit

// MARK: StorageKey
private enum StorageKeys: String, StorageKey {
    case name
    case email
}

// MARK: DemoStorageViewController
class DemoStorageViewController: FormsTableViewController {
    private lazy var storageNameTextField = Components.input.textField.default()
        .with(text: self.storageName)
        .with(title: "Storage name")
    private lazy var storageEmailTextField = Components.input.textField.email.default()
        .with(text: self.storageEmail)
        .with(title: "Storage email")
    private lazy var storageSecureNameTextField = Components.input.textField.default()
        .with(text: self.storageSecureName)
        .with(title: "Storage Secure name")
    private lazy var storageSecureEmailTextField = Components.input.textField.email.default()
        .with(text: self.storageSecureEmail)
        .with(title: "Storage Secure email")
    private let clearButton = Components.button.default()
        .with(title: "Clear")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    @Storage(StorageKeys.name)
    private var storageName: String? // swiftlint:disable:this let_var_whitespace
    
    @StorageWithDefault(StorageKeys.email, "example@email.com")
    private var storageEmail: String // swiftlint:disable:this let_var_whitespace
    
    @StorageSecure(StorageKeys.name)
    private var storageSecureName: String? // swiftlint:disable:this let_var_whitespace
    
    @StorageSecureWithDefault(StorageKeys.email, "example@email.com")
    private var storageSecureEmail: String // swiftlint:disable:this let_var_whitespace
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.storageNameTextField,
            self.storageEmailTextField,
            self.storageSecureNameTextField,
            self.storageSecureEmailTextField,
            self.clearButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.storageNameTextField.onEndEditing = Unowned(self) { (_self, text) in
            _self.storageName = text
        }
        self.storageEmailTextField.onEndEditing = Unowned(self) { (_self, text) in
            _self.storageEmail = text ?? ""
        }
        self.storageSecureNameTextField.onEndEditing = Unowned(self) { (_self, text) in
            _self.storageSecureName = text
        }
        self.storageSecureEmailTextField.onEndEditing = Unowned(self) { (_self, text) in
            _self.storageSecureEmail = text ?? ""
        }
        self.clearButton.onClick = Unowned(self) { (_self) in
            _self._storageName.remove()
            _self._storageEmail.remove()
            _self._storageSecureName.remove()
            _self._storageSecureEmail.remove()
            _self.navigationController?.popViewController(animated: true)
        }
    }
}
