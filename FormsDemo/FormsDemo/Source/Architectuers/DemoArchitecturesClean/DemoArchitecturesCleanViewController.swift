//
//  DemoArchitecturesCleanViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Anchor
import Forms
import UIKit

// MARK: DemoArchitecturesCleanDisplayLogic
protocol DemoArchitecturesCleanDisplayLogic: class {
    func displayContent(_ viewModel: DemoArchitecturesClean.GetContent.ViewModel)
}

// MARK: DemoArchitecturesCleanViewController
class DemoArchitecturesCleanViewController: FormsViewController {
    var interactor: DemoArchitecturesCleanBusinessLogic!
    var router: DemoArchitecturesCleanRoutingLogic!
    
    private let titleLabel = Components.label.default()
        .with(alignment: .center)
        .with(text: "Random number generator")
    private let generateButton = Components.button.default()
        .with(title: "Generate")
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.titleLabel, with: [
            Anchor.to(self.view).top.safeArea.offset(16),
            Anchor.to(self.view).horizontal.offset(16)
        ])
        self.view.addSubview(self.generateButton, with: [
            Anchor.to(self.titleLabel).topToBottom.offset(16),
            Anchor.to(self.view).horizontal.offset(16)
        ])
    }
    
    override func setupActions() {
        super.setupActions()
        self.generateButton.onClick = { [unowned self] in
            self.getContent()
        }
    }
}

// MARK: DemoArchitecturesCleanDisplayLogic
extension DemoArchitecturesCleanViewController: DemoArchitecturesCleanDisplayLogic {
    private func getContent() {
        Loader.show(in: self.navigationController)
        let request = DemoArchitecturesClean.GetContent.Request()
        self.interactor.getContent(request)
    }
    
    func displayContent(_ viewModel: DemoArchitecturesClean.GetContent.ViewModel) {
        Loader.hide(in: self.navigationController)
        self.router.routeToSummary()
    }
}
