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
    
    @Storage(StorageKeys.name)
    private var storageName: String? // swiftlint:disable:this let_var_whitespace
    
    @StorageWithDefault(StorageKeys.email, "example@email.com")
    private var storageEmail: String // swiftlint:disable:this let_var_whitespace
    
    @StorageSecure(StorageKeys.name)
    private var storageSecureName: String? // swiftlint:disable:this let_var_whitespace
    
    @StorageSecureWithDefault(StorageKeys.email, "example@email.com")
    private var storageSecureEmail: String // swiftlint:disable:this let_var_whitespace
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
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
        self.storageNameTextField.onEndEditing = { [unowned self] (text) in
            self.storageName = text
        }
        self.storageEmailTextField.onEndEditing = { [unowned self] (text) in
            self.storageEmail = text ?? ""
        }
        self.storageSecureNameTextField.onEndEditing = { [unowned self] (text) in
            self.storageSecureName = text
        }
        self.storageSecureEmailTextField.onEndEditing = { [unowned self] (text) in
            self.storageSecureEmail = text ?? ""
        }
        self.clearButton.onClick = { [unowned self] () in
            self._storageName.remove()
            self._storageEmail.remove()
            self._storageSecureName.remove()
            self._storageSecureEmail.remove()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
