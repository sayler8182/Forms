//
//  Forms.swift
//  Forms
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsLogger
import FormsNetworking
import FormsUtils
import FormsUtilsUI
import FormsValidators
import UIKit

// MARK: Module
enum Module: String {
    case forms = "Forms"
    case formsAnalytics = "FormsAnalytics"
    case formsAnchor = "FormsAnchor"
    case formsAppStoreReview = "FormsAppStoreReview"
    case formsCalendarKit = "FormsCalendarKit"
    case formsCardKit = "FormsCardKit"
    case formsDatabase = "FormsDatabase"
    case formsDatabaseSQLite = "FormsDatabaseSQLite"
    case formsDeveloperTools = "FormsDeveloperTools"
    case formsHomeShortcuts = "FormsHomeShortcuts"
    case formsImagePicker = "FormsImagePicker"
    case formsInjector = "FormsInjector"
    case formsLocation = "FormsLocation"
    case formsLogger = "FormsLogger"
    case formsMock = "FormsMock"
    case formsNetworking = "FormsNetworking"
    case formsNotifications = "FormsNotifications"
    case formsPagerKit = "FormsPagerKit"
    case formsPermissions = "FormsPermissions"
    case formsSideMenu = "FormsSideMenu"
    case formsTabBarKit = "FormsTabBarKit"
    case formsToastKit = "FormsToastKit"
    case formsTransition = "FormsTransition"
    case formsUtils = "FormsUtils"
    case formsUtilsUI = "FormsUtilsUI"
    case formsValidators = "FormsValidators"
}

// MARK: Forms
public enum Forms {
    public private (set) static var injector: Injector = Injector.main
    
    public static func configure(_ injector: Injector = Injector.main,
                                 _ assemblies: [Assembly] = []) {
        Forms.injector = injector
        Forms.configureBase(injector)
        Forms.configureConfigurations(injector)
        Forms.configureNetworking(injector)
        Forms.configureAssemblies(injector, assemblies)
    }
    
    private static func configureBase(_ injector: Injector) {
        // logger
        injector.register(Logger.self) { _ in
            ConsoleLogger()
        }
        injector.register(Logger.self, module: Module.formsNetworking.rawValue) { _ in
            ConsoleLogger()
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
                .black: UIColor(rgba: 0x000000FF),
                .blue: UIColor(rgba: 0x007AFFFF),
                .gray: UIColor(rgba: 0x8E8E93FF),
                .green: UIColor(rgba: 0x34C759FF),
                .orange: UIColor(rgba: 0xFFA500FF),
                .red: UIColor(rgba: 0xFF3B30FF),
                .white: UIColor(rgba: 0xFFFFFFFF),
                .primaryDark: UIColor(rgba: 0x000000FF),
                .secondaryDark: UIColor(rgba: 0x3C3C4399),
                .tertiaryDark: UIColor(rgba: 0x5C5C63FF),
                .primaryLight: UIColor(rgba: 0xFFFFFFFF),
                .secondaryLight: UIColor(rgba: 0xF2F2F7FF),
                .tertiaryLight: UIColor(rgba: 0xC2C2C2FF)
            ], statusBar: .dark)
        }
        .inScope(InjectorScope.container)
        injector.register(ThemeColorsProtocol.self, name: ThemeType.dark.key) { _ in
            ThemeColors(colors: [
                .black: UIColor(rgba: 0x000000FF),
                .blue: UIColor(rgba: 0x0A84FFFF),
                .gray: UIColor(rgba: 0x8E8E93FF),
                .green: UIColor(rgba: 0x30D158FF),
                .orange: UIColor(rgba: 0xFFA500FF),
                .red: UIColor(rgba: 0xFF375FFF),
                .white: UIColor(rgba: 0xFFFFFFFF),
                .primaryDark: UIColor(rgba: 0xFFFFFFFF),
                .secondaryDark: UIColor(rgba: 0xF2F2F7FF),
                .tertiaryDark: UIColor(rgba: 0xC2C2C2FF),
                .primaryLight: UIColor(rgba: 0x000000FF),
                .secondaryLight: UIColor(rgba: 0x3C3C4399),
                .tertiaryLight: UIColor(rgba: 0x5C5C63FF)
            ], statusBar: .light)
        }
        .inScope(InjectorScope.container)
        injector.register(ThemeFontsProtocol.self) { _ in
            ThemeFonts(fonts: [
                .bold: { UIFont.systemFont(ofSize: $0, weight: .bold) },
                .light: { UIFont.systemFont(ofSize: $0, weight: .light) },
                .medium: { UIFont.systemFont(ofSize: $0, weight: .medium) },
                .regular: { UIFont.systemFont(ofSize: $0, weight: .regular) }
            ])
        }
        .inScope(InjectorScope.container)
        // utils
        injector.register(BiometryAuthenticationProtocol.self) { _ in
            BiometryAuthentication()
        }
        .inScope(InjectorScope.container)
        injector.register(DeviceSecurityProtocol.self) { _ in
            DeviceSecurity()
        }
        .inScope(InjectorScope.container)
        injector.register(SettingsBundleProtocol.self) { _ in
            SettingsBundle()
        }
        .inScope(InjectorScope.container)
    }
    
    private static func configureConfigurations(_ injector: Injector) {
        // loader
        injector.register(ConfigurationLoaderProtocol.self) { _ in
            Configuration.Loader()
        }
        // modal
        injector.register(ConfigurationModalProtocol.self) { _ in
            Configuration.Modal()
        }
    }
    
    private static func configureNetworking(_ injector: Injector) {
        injector.register(NetworkProviderProtocol.self) { (r) in
            let session: NetworkSessionProtocol? = r.resolve(NetworkSessionProtocol.self)
            return NetworkProvider()
                .with(session: session)
        }
        injector.register(NetworkSessionProtocol.self) { _ in
            NetworkSession()
        }
    }
    
    private static func configureAssemblies(_ injector: Injector,
                                            _ assemblies: [Assembly]) {
        Self.assemble(injector, assemblies)
    }
    
    public static func assemble(_ injector: Injector,
                                _ assemblies: [Assembly]) {
        injector.assemble(assemblies)
    }
}
