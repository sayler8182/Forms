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

public func measure(_ key: String,
                    _ action: () -> Void) {
    let startDate: TimeInterval = Date().timeIntervalSince1970
    action()
    let endDate: TimeInterval = Date().timeIntervalSince1970
    print("Measure - \(key)", endDate - startDate)
}

public func getObject<T>(_ object: Any,
                         _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

public func setObject<T>(_ object: Any,
                         _ key: UnsafeRawPointer,
                         _ value: T,
                         _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
    objc_setAssociatedObject(object, key, value, policy)
}
