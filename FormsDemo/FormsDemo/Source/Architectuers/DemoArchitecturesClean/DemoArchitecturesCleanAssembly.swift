//
//  DemoArchitecturesCleanAssembly.swift
//  FormsDemo
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms

// MARK: DemoArchitecturesCleanAssembly
struct DemoArchitecturesCleanAssembly: Assembly {
    func assemble(injector: Injector) {
        injector.register(DemoArchitecturesCleanViewController.self) { _ in
            let interactor = DemoArchitecturesCleanInteractor()
            let presenter = DemoArchitecturesCleanPresenter()
            let router = DemoArchitecturesCleanRouter()
            let controller = DemoArchitecturesCleanViewController()
            let worker = DemoArchitecturesCleanWorker()
            interactor.presenter = presenter
            interactor.worker = worker
            presenter.controller = controller
            controller.interactor = interactor
            controller.router = router
            router.controller = controller
            router.dataStore = interactor
            return controller
        }
    }
}
