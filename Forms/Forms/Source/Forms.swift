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
import FormsValidators
import UIKit

// MARK: Module
enum Module: String {
    case forms = "Forms"
    case formsAnalytics = "FormsAnalytics"
    case formsAnchor = "FormsAnchor"
    case formsAppStoreReview = "FormsAppStoreReview"
    case formsCardKit = "FormsCardKit"
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
                .blue: UIColor(rgba: 0x007AFFFF),
                .gray: UIColor(rgba: 0x8E8E93FF),
                .green: UIColor(rgba: 0x34C759FF),
                .orange: UIColor(rgba: 0xFFA500FF),
                .red: UIColor(rgba: 0xFF3B30FF),
                .primaryDark: UIColor(rgba: 0x000000FF),
                .secondaryDark: UIColor(rgba: 0x3C3C4399),
                .tertiaryDark: UIColor(rgba: 0x3C3C434D),
                .primaryLight: UIColor(rgba: 0xFFFFFFFF),
                .secondaryLight: UIColor(rgba: 0xF2F2F7FF),
                .tertiaryLight: UIColor(rgba: 0xFFFFFFFF)
            ], statusBar: .dark)
        }
        .inScope(InjectorScope.container)
        injector.register(ThemeColorsProtocol.self, name: ThemeType.dark.key) { _ in
            ThemeColors(colors: [
                .blue: UIColor(rgba: 0x0A84FFFF),
                .gray: UIColor(rgba: 0x8E8E93FF),
                .green: UIColor(rgba: 0x30D158FF),
                .orange: UIColor(rgba: 0xFFA500FF),
                .red: UIColor(rgba: 0xFF375FFF),
                .primaryDark: UIColor(rgba: 0xFFFFFFFF),
                .secondaryDark: UIColor(rgba: 0xEBEBF599),
                .tertiaryDark: UIColor(rgba: 0xEBEBF54D),
                .primaryLight: UIColor(rgba: 0x000000FF),
                .secondaryLight: UIColor(rgba: 0x1C1C1EFF),
                .tertiaryLight: UIColor(rgba: 0x2C2C2EFF)
            ], statusBar: .light)
        }
        .inScope(InjectorScope.container)
        injector.register(ThemeFontsProtocol.self) { _ in
            ThemeFonts(fonts: [
                .bold: { UIFont.boldSystemFont(ofSize: $0) },
                .regular: { UIFont.systemFont(ofSize: $0) }
            ])
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
            return NetworkProvider(session: session)
        }
        injector.register(NetworkSessionProtocol.self) { _ in
            NetworkSession()
        }
        injector.register(NetworkImagesProtocol.self) { _ in
            NetworkImages()
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
