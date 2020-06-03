//
//  DemoArchitecturesCleanSummaryInteractor.swift
//  FormsDemo
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DemoArchitecturesCleanSummaryBusinessLogic
protocol DemoArchitecturesCleanSummaryBusinessLogic {
    func getContent(_ request: DemoArchitecturesCleanSummary.GetContent.Request)
}

// MARK: DemoArchitecturesCleanSummaryDataStore
protocol DemoArchitecturesCleanSummaryDataStore {
    var generated: Int? { get set }
}

// MARK: DemoArchitecturesCleanSummaryInteractor
class DemoArchitecturesCleanSummaryInteractor: DemoArchitecturesCleanSummaryBusinessLogic, DemoArchitecturesCleanSummaryDataStore {
    var presenter: DemoArchitecturesCleanSummaryPresentationLogic!
    var worker: DemoArchitecturesCleanSummaryWorker!

    var generated: Int?
    
    func getContent(_ request: DemoArchitecturesCleanSummary.GetContent.Request) {
        let response = DemoArchitecturesCleanSummary.GetContent.Response(
            generated: self.generated)
        self.presenter.presentContent(response)
    }
}
