//
//  DatabaseProviderProtocol.swift
//  FormsDatabase
//
//  Created by Konrad on 9/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: DatabaseProviderProtocol
public protocol DatabaseProviderProtocol: class {
    init(path: String,
         migration: Int) throws
}
