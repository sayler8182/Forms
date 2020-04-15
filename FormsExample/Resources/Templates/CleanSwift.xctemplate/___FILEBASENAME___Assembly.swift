//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: ___VARIABLE_sceneName___Assembly
class ___VARIABLE_sceneName___Assembly: Assembly {
    func assemble(injector: Injector) {
        injector.register(___VARIABLE_sceneName___ViewController.self) { _ in
            let interactor = ___VARIABLE_sceneName___Interactor()
            let presenter = ___VARIABLE_sceneName___Presenter()
            let router = ___VARIABLE_sceneName___Router()
            let controller = ___VARIABLE_sceneName___ViewController()
            let worker = ___VARIABLE_sceneName___Worker()
            interactor.presenter = presenter
            interactor.worker = worker
            presenter.controller = controller
            controller.interactor = interactor
            controller.router = router
            router.controller = controller
            router.dataStore = interactor
            return controller
        }
    } 
}
