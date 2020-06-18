//
//  Logger.swift
//  FormsDemo
//
//  Created by Konrad on 6/18/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsLogger

// MARK: CustomLogType
public enum CustomLogType: String, CaseIterable, LogTypeProtocol {
    case info
    case warning
    case error
}
