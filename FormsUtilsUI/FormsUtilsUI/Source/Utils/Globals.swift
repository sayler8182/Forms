//
//  Globals.swift
//  FormsUtilsUI
//
//  Created by Konrad on 6/29/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

public func performFor(osVersion range: Range<Double>,
                       action: () -> Void) {
    guard let varsion: Double = UIDevice.current.systemVersion.asDouble else { return }
    guard range.contains(varsion) else { return }
    action()
}

public func performFor(osVersion range: PartialRangeFrom<Double>,
                       action: () -> Void) {
    guard let varsion: Double = UIDevice.current.systemVersion.asDouble else { return }
    guard range.contains(varsion) else { return }
    action()
}

public func performFor(osVersion range: PartialRangeUpTo<Double>,
                       action: () -> Void) {
    guard let varsion: Double = UIDevice.current.systemVersion.asDouble else { return }
    guard range.contains(varsion) else { return }
    action()
}

public func valueFor<T>(osVersion range: Range<Double>,
                        _ value: T?) -> T? {
    guard let varsion: Double = UIDevice.current.systemVersion.asDouble else { return nil }
    guard range.contains(varsion) else { return nil }
    return value
}

public func valueFor<T>(osVersion range: PartialRangeFrom<Double>,
                        _ value: T?) -> T? {
    guard let varsion: Double = UIDevice.current.systemVersion.asDouble else { return nil }
    guard range.contains(varsion) else { return nil }
    return value
}

public func valueFor<T>(osVersion range: PartialRangeUpTo<Double>,
                        _ value: T?) -> T? {
    guard let varsion: Double = UIDevice.current.systemVersion.asDouble else { return nil }
    guard range.contains(varsion) else { return nil }
    return value
}
