//
//  Utils.swift
//  FormsDemo
//
//  Created by Konrad on 4/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

internal class Utils {
    static func delay(_ delay: Double,
                      _ action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            action()
        }
    }
}
