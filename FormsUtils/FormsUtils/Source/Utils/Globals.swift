//
//  Globals.swift
//  FormsUtils
//
//  Created by Konrad on 5/29/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public func delay(_ delay: Double,
                  _ action: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
        action()
    }
}

public func delay<T: AnyObject>(_ delay: Double,
                                _ target: T,
                                _ action: @escaping (T) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) { [weak target] in
        guard let target: T = target else { return }
        action(target)
    }
}
