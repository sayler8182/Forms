//
//  DemoArchitecturesCleanSummaryPresenter.swift
//  FormsDemo
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoArchitecturesCleanSummaryPresentationLogic
protocol DemoArchitecturesCleanSummaryPresentationLogic {
    func presentContent(_ response: DemoArchitecturesCleanSummary.GetContent.Response)
}

// MARK: DemoArchitecturesCleanSummaryPresenter
class DemoArchitecturesCleanSummaryPresenter: DemoArchitecturesCleanSummaryPresentationLogic {
    weak var controller: DemoArchitecturesCleanSummaryDisplayLogic!
  
    func presentContent(_ response: DemoArchitecturesCleanSummary.GetContent.Response) {
        DispatchQueue.main.async {
            let viewModel = DemoArchitecturesCleanSummary.GetContent.ViewModel(
                generated: response.generated?.description ?? "No data has been passed")
            self.controller.displayContent(viewModel)
        }
    }
}
