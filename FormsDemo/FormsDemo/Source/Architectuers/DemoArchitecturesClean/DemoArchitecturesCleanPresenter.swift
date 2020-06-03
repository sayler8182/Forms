//
//  DemoArchitecturesCleanPresenter.swift
//  FormsDemo
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DemoArchitecturesCleanPresentationLogic
protocol DemoArchitecturesCleanPresentationLogic {
    func presentGetContent(_ respone: DemoArchitecturesClean.GetContent.Respone)
}

// MARK: DemoArchitecturesCleanPresenter
class DemoArchitecturesCleanPresenter: DemoArchitecturesCleanPresentationLogic {
    weak var controller: DemoArchitecturesCleanDisplayLogic!
    
    func presentGetContent(_ response: DemoArchitecturesClean.GetContent.Respone) {
        DispatchQueue.main.async {
            let viewModel = DemoArchitecturesClean.GetContent.ViewModel(
                generated: response.generated.description)
            self.controller.displayContent(viewModel)
        }
    }
}
