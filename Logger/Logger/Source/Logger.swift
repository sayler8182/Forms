//
//  Logger.swift
//  Logger
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation
import os.log

// MARK: LoggerProtocol
public protocol LoggerProtocol {
   func log(_ string: String)
}

// MARK: Logger
public class Logger: LoggerProtocol {
    public init() { }
    
    public func log(_ string: String) {
        self.logConsole(string)
        self.logSystem(string)
    }
    
    private func logConsole(_ string: String) {
        print(string)
    }
    
    private func logSystem(_ string: String) {
        let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "com.limbo.Forms.Logger"
        let log: OSLog = OSLog(subsystem: bundleIdentifier, category: "logger")
        os_log("%{PRIVATE}@", log: log, type: .default, string)
    }
}
