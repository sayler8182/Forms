//
//  DemoStorageViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/23/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: StorageKey
private enum StorageKeys: String, StorageKey {
    case name
    case email
}

// MARK: DemoStorageViewController
class DemoStorageViewController: TableViewController {
    private lazy var storageNameTextField = Components.input.defaultTextField()
        .with(text: self.storageName)
        .with(title: "Name")
    private lazy var storageEmailTextField = Components.input.defaultEmailTextField()
        .with(text: self.storageEmail)
        .with(title: "Email")
    private lazy var storageKeychainNameTextField = Components.input.defaultTextField()
        .with(text: self.storageKeychainName)
        .with(title: "Name")
    private lazy var storageKeychainEmailTextField = Components.input.defaultEmailTextField()
        .with(text: self.storageKeychainEmail)
        .with(title: "Email")
    private let clearButton = Components.button.default()
        .with(title: "Clear")
    
    @Storage(StorageKeys.name)
    private var storageName: String? // swiftlint:disable:this let_var_whitespace
    
    @StorageWithDefault(StorageKeys.email, "example@email.com")
    private var storageEmail: String // swiftlint:disable:this let_var_whitespace
    
    @StorageKeychain(StorageKeys.name)
    private var storageKeychainName: String? // swiftlint:disable:this let_var_whitespace
    
    @StorageKeychainWithDefault(StorageKeys.email, "example@email.com")
    private var storageKeychainEmail: String // swiftlint:disable:this let_var_whitespace
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.storageNameTextField,
            self.storageEmailTextField,
            self.storageKeychainNameTextField,
            self.storageKeychainEmailTextField,
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
        self.storageKeychainNameTextField.onEndEditing = { [unowned self] (text) in
            self.storageKeychainName = text
        }
        self.storageKeychainEmailTextField.onEndEditing = { [unowned self] (text) in
            self.storageKeychainEmail = text ?? ""
        }
        self.clearButton.onClick = { [unowned self] () in
            self._storageName.clear()
            self._storageEmail.clear()
            self._storageKeychainName.clear()
            self._storageKeychainEmail.clear()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
