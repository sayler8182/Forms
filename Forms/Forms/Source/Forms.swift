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
        // date format
        injector.register(DateFormatProtocol.self) { _ in
            DateFormat(
                dateFormat: "yyyy-MM-dd",
                timeFormat: "HH:mm",
                fullFormat: "yyyy-MM-dd HH:mm")
        }
        // number format
        injector.register(NumberFormatProtocol.self) { _ in
            NumberFormat(
                fractionDigits: 2,
                groupingSeparator: " ",
                decimalSeparator: ",")
        }
        // theme
        injector.register(ThemeColorsProtocol.self, name: ThemeType.light.key) { _ in
            ThemeColors(colors: [
                .blue: UIColor(rgba: 0x007AFFFF),
                .gray: UIColor(rgba: 0x8E8E93FF),
                .green: UIColor(rgba: 0x34C759FF),
                .red: UIColor(rgba: 0xFF3B30FF),
                .primaryText: UIColor(rgba: 0x000000FF),
                .secondaryText: UIColor(rgba: 0x3C3C4399),
                .tertiaryText: UIColor(rgba: 0x3C3C434D),
                .primaryBackground: UIColor(rgba: 0xFFFFFFFF),
                .secondaryBackground: UIColor(rgba: 0xF2F2F7FF),
                .tertiaryBackground: UIColor(rgba: 0xFFFFFFFF)
            ], statusBar: .dark)
        }
        injector.register(ThemeColorsProtocol.self, name: ThemeType.dark.key) { _ in
            ThemeColors(colors: [
                .blue: UIColor(rgba: 0x0A84FFFF),
                .gray: UIColor(rgba: 0x8E8E93FF),
                .green: UIColor(rgba: 0x30D158FF),
                .red: UIColor(rgba: 0xFF375FFF),
                .primaryText: UIColor(rgba: 0xFFFFFFFF),
                .secondaryText: UIColor(rgba: 0xEBEBF599),
                .tertiaryText: UIColor(rgba: 0xEBEBF54D),
                .primaryBackground: UIColor(rgba: 0x000000FF),
                .secondaryBackground: UIColor(rgba: 0x1C1C1EFF),
                .tertiaryBackground: UIColor(rgba: 0x2C2C2EFF)
            ], statusBar: .light)
        }
        injector.register(ThemeFontsProtocol.self) { _ in
            ThemeFonts(fonts: [
                .bold: { UIFont.boldSystemFont(ofSize: $0) },
                .regular: { UIFont.systemFont(ofSize: $0) }
            ])
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
                    info: Theme.Colors.primaryBackground,
                    success: Theme.Colors.green,
                    error: Theme.Colors.red)
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
        Self.assemble(injector, assemblies)
    }
    
    public static func assemble(_ injector: Injector,
                                _ assemblies: [Assembly]) {
        injector.assemble(assemblies)
    }
}
