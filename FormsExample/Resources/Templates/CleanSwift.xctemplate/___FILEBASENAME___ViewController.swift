//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import Forms
import UIKit

// MARK: ___VARIABLE_sceneName___DisplayLogic
protocol ___VARIABLE_sceneName___DisplayLogic: class {
    func displayContent(_ viewModel: ___VARIABLE_sceneName___.GetContent.ViewModel)
}

// MARK: ___VARIABLE_sceneName___ViewController
class ___VARIABLE_sceneName___ViewController: FormsViewController {
    var interactor: ___VARIABLE_sceneName___BusinessLogic!
    var router: (___VARIABLE_sceneName___RoutingLogic & ___VARIABLE_sceneName___DataPassing)!

    override func setupContent() {
        super.setupContent()
    }
}

// MARK: ___VARIABLE_sceneName___DisplayLogic
extension ___VARIABLE_sceneName___ViewController: ___VARIABLE_sceneName___DisplayLogic {
    private func getContent() {
        let request = ___VARIABLE_sceneName___.GetContent.Request()
        self.interactor.getContent(request)
    }

    func displayContent(_ viewModel: ___VARIABLE_sceneName___.GetContent.ViewModel) {
    }
}
