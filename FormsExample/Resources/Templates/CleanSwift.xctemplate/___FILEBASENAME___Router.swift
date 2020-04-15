//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: ___VARIABLE_sceneName___RoutingLogic
protocol ___VARIABLE_sceneName___RoutingLogic { }

// MARK: ___VARIABLE_sceneName___DataPassing
protocol ___VARIABLE_sceneName___DataPassing {
    var dataStore: ___VARIABLE_sceneName___DataStore! { get }
}

// MARK: ___VARIABLE_sceneName___Router
class ___VARIABLE_sceneName___Router: ___VARIABLE_sceneName___RoutingLogic, ___VARIABLE_sceneName___DataPassing {
    weak var controller: ___VARIABLE_sceneName___ViewController!
    var dataStore: ___VARIABLE_sceneName___DataStore!
    private let injector: Injector = Forms.injector
}
