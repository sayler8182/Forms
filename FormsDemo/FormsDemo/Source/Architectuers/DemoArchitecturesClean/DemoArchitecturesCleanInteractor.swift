//
//  DemoArchitecturesCleanInteractor.swift
//  FormsDemo
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DemoArchitecturesCleanBusinessLogic
protocol DemoArchitecturesCleanBusinessLogic {
    func getContent(_ request: DemoArchitecturesClean.GetContent.Request)
}

// MARK: DemoArchitecturesCleanDataStore
protocol DemoArchitecturesCleanDataStore {
    var generated: Int? { get }
}

// MARK: DemoArchitecturesCleanInteractor
class DemoArchitecturesCleanInteractor: DemoArchitecturesCleanBusinessLogic, DemoArchitecturesCleanDataStore {
    var presenter: DemoArchitecturesCleanPresentationLogic!
    var worker: DemoArchitecturesCleanWorker!
    
    var generated: Int?
    
    func getContent(_ request: DemoArchitecturesClean.GetContent.Request) {
        self.worker.getRandomNumber { [weak self] (number) in
            guard let `self` = self else { return }
            self.generated = number
            let respone = DemoArchitecturesClean.GetContent.Respone(
                generated: number)
            self.presenter.presentGetContent(respone)
        }
    }
}
