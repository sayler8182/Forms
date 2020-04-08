//
//  Forms.swift
//  Forms
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public struct Forms {
    public private (set) static var injector: Injector = Injector.main
    
    private init() { }
    
    public static func initialize(_ injector: Injector) {
        Forms.injector = injector
        self.initializeBase(injector: injector)
        self.initializeConfigurations(injector: injector)
    }
    
    private static func initializeBase(injector: Injector) {
        // validators
        injector.register(ValidatorTranslatorProtocol.self) { _ in
            ValidatorTranslator()
        }
        // number format
        injector.register(NumberFormatProtocol.self) { _ in
            NumberFormat(
                groupingSeparator: " ",
                decimalSeparator: ",")
        }
        // theme
        injector.register(ThemeProtocol.self) { _ in
            Theme()
        }
    }
    private static func initializeConfigurations(injector: Injector) {
        // loader
        injector.register(ConfigurationLoaderProtocol.self) { _ in
            Configuration.Loader()
        }
        // modal
        injector.register(ConfigurationModalProtocol.self) { _ in
            Configuration.Modal()
        }
        // toast
        injector.register(ConfigurationToastProtocol.self) { r in
            let theme: ThemeProtocol = r.resolve(ThemeProtocol.self)
            return Configuration.Toast(
                backgroundColor: .init(
                    info: UIColor.black,
                    success: theme.greenColor,
                    error: theme.redColor)
            )
        }
    }
}
