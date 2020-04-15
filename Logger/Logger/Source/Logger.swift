//
//  Logger.swift
//  Logger
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: LoggerProtocol
public protocol LoggerProtocol {
   func log(_ string: String)
}

// MARK: Logger
public class Logger: LoggerProtocol {
    public init() { }
    
    public func log(_ string: String) {
        print(string)
    }
}
