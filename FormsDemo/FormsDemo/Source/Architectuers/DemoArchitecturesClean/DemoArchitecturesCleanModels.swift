//
//  DemoArchitecturesCleanModels.swift
//  FormsDemo
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DemoArchitecturesClean
enum DemoArchitecturesClean {
    enum GetContent {
        struct Request { }
        struct Respone {
            let generated: Int
        }
        struct ViewModel {
            let generated: String
        }
    }
}
