//
//  DemoArchitecturesCleanSummaryRouter.swift
//  FormsDemo
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoArchitecturesCleanSummaryRoutingLogic
protocol DemoArchitecturesCleanSummaryRoutingLogic { }

// MARK: DemoArchitecturesCleanSummaryDataPassing
protocol DemoArchitecturesCleanSummaryDataPassing {
    var dataStore: DemoArchitecturesCleanSummaryDataStore! { get }
}

// MARK: DemoArchitecturesCleanSummaryRouter
class DemoArchitecturesCleanSummaryRouter: DemoArchitecturesCleanSummaryRoutingLogic, DemoArchitecturesCleanSummaryDataPassing {
    weak var controller: DemoArchitecturesCleanSummaryViewController!
    var dataStore: DemoArchitecturesCleanSummaryDataStore!
    private let injector: Injector = Forms.injector
}
