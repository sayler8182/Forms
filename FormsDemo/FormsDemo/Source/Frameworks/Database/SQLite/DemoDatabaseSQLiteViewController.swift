//
//  DemoDatabaseSQLiteViewController.swift
//  FormsDemo
//
//  Created by Konrad on 9/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsDatabase
import FormsDatabaseSQLite
import FormsInjector
import FormsLogger
import FormsMock
import FormsUtils
import UIKit

// MARK: DemoDatabaseSQLiteViewController
class DemoDatabaseSQLiteViewController: FormsTableViewController {
    private let statusLabel = Components.label.default()
        .with(alignment: .center)
        .with(numberOfLines: 0)
    private let connectionButton = Components.button.default()
    private let versionButton = Components.button.default()
        .with(title: "Check version")
    private let structureButton = Components.button.default()
        .with(title: "Database structure")
    private let addModelsButton = Components.button.default()
        .with(title: "Add models")
    private let removeModelsButton = Components.button.default()
        .with(title: "Remove models")
    private let showModelsButton = Components.button.default()
        .with(title: "Show models")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    @Injected
    private var database: DatabaseSQLite // swiftlint:disable:this let_var_whitespace
    
    @Injected
    private var logger: Logger // swiftlint:disable:this let_var_whitespace
    
    override func setupView() {
        super.setupView()
        self.updateConnection()
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.statusLabel,
            self.connectionButton,
            self.versionButton,
            self.structureButton,
            self.addModelsButton,
            self.removeModelsButton,
            self.showModelsButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.connectionButton.onClick = Unowned(self) { (_self) in
            _self.database.isConnected
                ? _self.disconnect()
                : _self.connect()
        }
        self.versionButton.onClick = Unowned(self) { (_self) in
            _self.checkVersion()
        }
        self.structureButton.onClick = Unowned(self) { (_self) in
            _self.structure()
        }
        self.addModelsButton.onClick = Unowned(self) { (_self) in
            _self.addModels()
        }
        self.removeModelsButton.onClick = Unowned(self) { (_self) in
            _self.removeModels()
        }
        self.showModelsButton.onClick = Unowned(self) { (_self) in
            _self.showModels()
        }
    }
    
    private func updateConnection() {
        self.updateTableView {
            self.connectionButton.title = self.database.isConnected
                ? "Disconnect"
                : "Connect"
            self.statusLabel.text = self.database.isConnected
                ? "Connected"
                : "Disconnected"
        }
    }
    
    private func connect() {
        do {
            try self.database.connect(to: DemoDatabaseSQLiteProvider.self, migration: 1)
            self.updateTableView {
                self.connectionButton.title = "Disconnect"
                self.statusLabel.text = "Connected"
            }
        } catch let error {
            self.updateTableView {
                self.statusLabel.text = error.localizedDescription
            }
        }
    }
    
    private func disconnect() {
        self.database.disconnect()
        self.updateTableView {
            self.connectionButton.title = "Connect"
            self.statusLabel.text = "Disconnected"
        }
    }
    
    private func checkVersion() {
        let version: String = self.database.version.description
        let migration: Int = self.database.migration
        self.updateTableView {
            self.statusLabel.text = migration < 0
                ? "Connection error"
                : String(format: "Version: %@ (%d)", version, migration)
        }
    }
    
    private func structure() {
        do {
            let info: String = try self.database.info()
            self.logger.log(LogType.info, info)
        } catch let error {
            self.updateTableView {
                self.statusLabel.text = error.localizedDescription
            }
        }
    }
}

// MARK: CRUD
extension DemoDatabaseSQLiteViewController {
    private func addModels() {
        do {
            let model: DemoSQLiteModel = DemoSQLiteModel.mock()
            let table = DatabaseSQLiteTableModels(self.database)
            try table.insertModels([model])
            self.updateTableView {
                self.statusLabel.text = "Model inserted"
            }
        } catch let error {
            self.updateTableView {
                self.statusLabel.text = error.localizedDescription
            }
        }
    }
    
    private func removeModels() {
        do {
            let table = DatabaseSQLiteTableModels(self.database)
            let models: [DemoSQLiteModel] = try table.selectModels()
            try table.removeModels(models)
            self.updateTableView {
                self.statusLabel.text = "Models removed"
            }
        } catch let error {
            self.updateTableView {
                self.statusLabel.text = error.localizedDescription
            }
        }
    }
    
    private func showModels() {
        do {
            let table = DatabaseSQLiteTableModels(self.database)
            let models: [DemoSQLiteModel] = try table.selectModels()
            if models.isNotEmpty {
                var info: String = ""
                info += "\n---\n"
                info += models
                    .map { $0.debugDescription }
                    .joined(separator: "\n\n")
                info += "\n---\n"
                self.logger.log(LogType.info, info)
            }
            self.updateTableView {
                self.statusLabel.text = models.isNotEmpty
                    ? "Models presented"
                    : "Models are empty"
            }
        } catch let error {
            self.updateTableView {
                self.statusLabel.text = error.localizedDescription
            }
        }
    }
}

// MARK: Model
public struct DemoSQLiteModel: Mockable, DatabaseSQLiteModel, CustomDebugStringConvertible {
    let id: String
    let name: String
    let description: String?
    let price: Double
    let count: Int
    
    public init(_ mock: Mock) {
        self.id = mock.uuid()
        self.name = mock.string()
        self.description = mock.string([.length(.long), .nullable(0.5)])
        self.price = mock.number(0..<100.0)
        self.count = mock.number(0..<20)
    }
    
    public init(_ row: DatabaseSQLiteRow) throws {
        self.id = try row.object(key: DatabaseSQLiteTableModels.Row.id, of: String.self)
        self.name = try row.object(key: DatabaseSQLiteTableModels.Row.name, of: String.self)
        self.description = try row.object(key: DatabaseSQLiteTableModels.Row.description, of: String?.self)
        self.price = try row.object(key: DatabaseSQLiteTableModels.Row.price, of: Double.self)
        self.count = try row.object(key: DatabaseSQLiteTableModels.Row.count, of: Int.self)
    }
    
    public var debugDescription: String {
        return """
        id: \(self.id)
        name: \(self.name)
        description: \(self.description.or("nil"))
        price: \(self.price)
        count: \(self.count)
        """
    }
}
