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
