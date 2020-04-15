//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: ___VARIABLE_sceneName___BusinessLogic
protocol ___VARIABLE_sceneName___BusinessLogic {
    func getContent(_ request: ___VARIABLE_sceneName___.GetContent.Request)
}

// MARK: ___VARIABLE_sceneName___DataStore
protocol ___VARIABLE_sceneName___DataStore {
}

// MARK: ___VARIABLE_sceneName___Interactor
class ___VARIABLE_sceneName___Interactor: ___VARIABLE_sceneName___BusinessLogic, ___VARIABLE_sceneName___DataStore {
    var presenter: ___VARIABLE_sceneName___PresentationLogic!
    var worker: ___VARIABLE_sceneName___Worker!

    func getContent(_ request: ___VARIABLE_sceneName___.GetContent.Request) {
        let response = ___VARIABLE_sceneName___.GetContent.Response()
        self.presenter.presentContent(response)
    }
}
