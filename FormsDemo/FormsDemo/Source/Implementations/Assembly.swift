//
//  Assembly.swift
//  FormsDemo
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAppStoreReview
import FormsDatabase
import FormsDatabaseSQLite
import FormsHomeShortcuts
import FormsInjector
import FormsUpdates
import UIKit

// MARK: DemoAssembly
public class DemoAssembly: Assembly {
    public init() { }
    
    public func assemble(injector: Injector) {
        injector.register(AppStoreReviewProtocol.self) { _ in
            AppStoreReview()
        }
        .inScope(InjectorScope.container)
        injector.register(DatabaseSQLite.self) { _ in
            DatabaseSQLite(version: "0.0.0")
        }
        .inScope(InjectorScope.container)
        injector.register(HomeShortcutsProtocol.self) { _ in
            HomeShortcuts()
        }
        .inScope(InjectorScope.container)
        injector.register(SharedContainerProtocol.self) { _ in
            SharedContainer("group.com.limbo.FormsExample")
        }
        .inScope(InjectorScope.container)
        injector.register(UpdatesProtocol.self) { _ in
            Updates(
                bundle: Bundle.main.bundleId,
                version: Bundle.main.appVersion)
        }
        .inScope(InjectorScope.container)
    }
}
