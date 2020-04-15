//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: ___VARIABLE_sceneName___PresentationLogic
protocol ___VARIABLE_sceneName___PresentationLogic {
    func presentContent(_ response: ___VARIABLE_sceneName___.GetContent.Response)
}

// MARK: ___VARIABLE_sceneName___Presenter
class ___VARIABLE_sceneName___Presenter: ___VARIABLE_sceneName___PresentationLogic {
    weak var controller: ___VARIABLE_sceneName___DisplayLogic!
  
    func presentContent(_ response: ___VARIABLE_sceneName___.GetContent.Response) {
        DispatchQueue.main.async {
            let viewModel = ___VARIABLE_sceneName___.GetContent.ViewModel()
            self.controller.displayContent(viewModel)
        }
    }
}
