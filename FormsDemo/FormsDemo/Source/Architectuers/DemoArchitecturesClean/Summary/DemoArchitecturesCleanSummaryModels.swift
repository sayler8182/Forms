//
//  DemoArchitecturesCleanSummaryModels.swift
//  FormsDemo
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DemoArchitecturesCleanSummary
enum DemoArchitecturesCleanSummary {
    enum GetContent {
        struct Request { }
        struct Response {
            var generated: Int?
        }
        struct ViewModel {
            var generated: String
        }
    }
}
