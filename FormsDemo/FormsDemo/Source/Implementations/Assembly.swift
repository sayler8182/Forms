//
//  Assembly.swift
//  FormsDemo
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsHomeShortcuts
import FormsInjector
import UIKit

// MARK: AppAssembly
public class DemoAssembly: Assembly {
    public init() { }
    
    public func assemble(injector: Injector) {
        injector.register(HomeShortcutsProtocol.self) { _ in
            HomeShortcuts()
        }
        .inScope(InjectorScope.container)
    }
}
