//
//  Forms.swift
//  Forms
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Injector
import Logger
import Permission
import UIKit
import Utils
import Validators

public struct Forms {
    public private (set) static var injector: Injector = Injector.main
    
    private init() { }
    
    public static func initialize(_ injector: Injector,
                                  _ assemblies: [Assembly] = []) {
        Forms.injector = injector
        Forms.initializeBase(injector)
        Forms.initializeConfigurations(injector)
        Forms.initializePermissions(injector)
        Forms.initializeAssemblies(injector, assemblies)
    }
    
    private static func initializeBase(_ injector: Injector) {
        // logger
        injector.register(LoggerProtocol.self) { _ in
            Logger()
        }
        // validators
        injector.register(ValidatorTranslatorProtocol.self) { _ in
            ValidatorTranslator()
        }
        // number format
        injector.register(NumberFormatProtocol.self) { _ in
            NumberFormat(
                groupingSeparator: "-",
                decimalSeparator: "_")
        }
        // theme
        injector.register(ThemeProtocol.self) { _ in
            Theme()
        }
    }
    
    private static func initializeConfigurations(_ injector: Injector) {
        // loader
        injector.register(ConfigurationLoaderProtocol.self) { _ in
            Configuration.Loader()
        }
        // modal
        injector.register(ConfigurationModalProtocol.self) { _ in
            Configuration.Modal()
        }
        // toast
        injector.register(ConfigurationToastProtocol.self) { _ in
            return Configuration.Toast(
                backgroundColor: .init(
                    info: UIColor.systemBackground,
                    success: UIColor.systemGreen,
                    error: UIColor.systemRed)
            )
        }
    }
    
    private static func initializePermissions(_ injector: Injector) {
        // location
        injector.register(PermissionLocationProtocol.self) { _ in
            Permission.Location()
        }
        // notifications
        injector.register(PermissionNotificationsProtocol.self) { _ in
            Permission.Notifications()
        }
    }
    
    private static func initializeAssemblies(_ injector: Injector,
                                             _ assemblies: [Assembly]) {
        injector.assemble(assemblies)
    }
}
