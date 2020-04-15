//
//  DemoArchitecturesCleanRouter.swift
//  FormsDemo
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoArchitecturesCleanRoutingLogic
protocol DemoArchitecturesCleanRoutingLogic {
    func routeToSummary()
}

// MARK: DemoArchitecturesCleanDataPassing
protocol DemoArchitecturesCleanDataPassing {
    var dataStore: DemoArchitecturesCleanDataStore! { get }
}

// MARK: DemoArchitecturesCleanRouter
class DemoArchitecturesCleanRouter: DemoArchitecturesCleanRoutingLogic, DemoArchitecturesCleanDataPassing {
    weak var controller: DemoArchitecturesCleanViewController!
    var dataStore: DemoArchitecturesCleanDataStore!
    private let injector: Injector = Forms.injector
    
    func routeToSummary() {
        let destinationVC: DemoArchitecturesCleanSummaryViewController = self.injector.resolve()
        var destinationDS: DemoArchitecturesCleanSummaryDataStore = destinationVC.router.dataStore
        self.passDataToSummary(source: self.dataStore, destination: &destinationDS)
        self.navigateToSummary(destination: destinationVC)
    }

    private func passDataToSummary(source: DemoArchitecturesCleanDataStore,
                                   destination: inout DemoArchitecturesCleanSummaryDataStore) {
        destination.generated = source.generated
    }
    
    private func navigateToSummary(destination: DemoArchitecturesCleanSummaryViewController) {
        self.controller.show(destination, sender: nil)
    }
}
