//
//  DemoArchitecturesCleanSummaryViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoArchitecturesCleanSummaryDisplayLogic
protocol DemoArchitecturesCleanSummaryDisplayLogic: class {
    func displayContent(_ viewModel: DemoArchitecturesCleanSummary.GetContent.ViewModel)
}

// MARK: DemoArchitecturesCleanSummaryViewController
class DemoArchitecturesCleanSummaryViewController: ViewController {
    var interactor: DemoArchitecturesCleanSummaryBusinessLogic!
    var router: (DemoArchitecturesCleanSummaryRoutingLogic & DemoArchitecturesCleanSummaryDataPassing)!

    private let titleLabel = Components.label.label()
        .with(alignment: .center)
        .with(text: "Summary")
    private let summaryLabel = Components.label.label()
        .with(alignment: .center)
    
    override func setupView() {
        super.setupView()
        self.getContent()
    }
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.titleLabel, with: [
            Anchor.to(self.view).top.safeArea.offset(16),
            Anchor.to(self.view).horizontal.offset(16)
        ])
        self.view.addSubview(self.summaryLabel, with: [
            Anchor.to(self.titleLabel).topToBottom.offset(16),
            Anchor.to(self.view).horizontal.offset(16)
        ])
    }
}

// MARK: DemoArchitecturesCleanSummaryDisplayLogic
extension DemoArchitecturesCleanSummaryViewController: DemoArchitecturesCleanSummaryDisplayLogic {
    private func getContent() {
        let request = DemoArchitecturesCleanSummary.GetContent.Request()
        self.interactor.getContent(request)
    }
    
    func displayContent(_ viewModel: DemoArchitecturesCleanSummary.GetContent.ViewModel) {
        self.summaryLabel.text = viewModel.generated
    }
}
