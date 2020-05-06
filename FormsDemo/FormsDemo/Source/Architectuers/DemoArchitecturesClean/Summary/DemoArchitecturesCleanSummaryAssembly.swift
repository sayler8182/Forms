//
//  DemoArchitecturesCleanSummaryAssembly.swift
//  FormsDemo
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import Injector

// MARK: DemoArchitecturesCleanSummaryAssembly
class DemoArchitecturesCleanSummaryAssembly: Assembly {
    func assemble(injector: Injector) {
        injector.register(DemoArchitecturesCleanSummaryViewController.self) { _ in
            let interactor = DemoArchitecturesCleanSummaryInteractor()
            let presenter = DemoArchitecturesCleanSummaryPresenter()
            let router = DemoArchitecturesCleanSummaryRouter()
            let controller = DemoArchitecturesCleanSummaryViewController()
            let worker = DemoArchitecturesCleanSummaryWorker()
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
