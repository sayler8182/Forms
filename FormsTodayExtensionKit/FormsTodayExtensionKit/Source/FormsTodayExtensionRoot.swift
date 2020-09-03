//
//  FormsTodayExtensionRoot.swift
//  FormsTodayExtensionKit
//
//  Created by Konrad on 9/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import Foundation

// MARK: FormsTodayExtensionRoot
public protocol FormsTodayExtensionRoot {
    var appURL: URL! { get }
    var groupIdentifier: String { get }
    
    func configure()
}
