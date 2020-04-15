//
//  DemoArchitecturesCleanWorker.swift
//  FormsDemo
//
//  Created by Konrad on 4/15/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DemoArchitecturesCleanWorker
class DemoArchitecturesCleanWorker {
    func getRandomNumber(completion: @escaping (Int) -> Void) {
        Utils.delay(1) {
            let number = Int.random(in: 0..<10)
            completion(number)
        }
    }
}
