//
//  TodayExtensionRoot.swift
//  FormsExampleTodayExtension
//
//  Created by Konrad on 9/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsInjector
import FormsTodayExtensionKit
import Foundation

// MARK: TodayExtensionAssembly
public class TodayExtensionAssembly: Assembly {
    public init() { }
    
    public func assemble(injector: Injector) {
        injector.register(SharedContainerProtocol.self) { _ in
            SharedContainer("group.com.limbo.FormsExample")
        }
        .inScope(InjectorScope.container)
    }
}

// MARK: TodayExtensionRoot
class TodayExtensionRoot: FormsTodayExtensionRoot {
    static var shared: TodayExtensionRoot = TodayExtensionRoot()
    
    private var isConfigured: Bool = false
    
    var appURL: URL! {
        return URL(string: "forms-example://")
    }
    var groupIdentifier: String {
        return "group.com.limbo.FormsExample"
    }
    
    func configure() {
        guard !self.isConfigured else { return }
        Forms.configure(Injector.main, [
            TodayExtensionAssembly()
        ])
        self.isConfigured = true
    }
}
