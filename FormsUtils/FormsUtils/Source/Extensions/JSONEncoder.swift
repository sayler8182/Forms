//
//  JSONEncoder.swift
//  FormsUtils
//
//  Created by Konrad on 8/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

private let kDateFormatter: DateFormatter = DateFormatter()
    
// MARK: JSONEncoder
public extension JSONEncoder {
    enum JSONEncoderError: String, Error {
        case jsonEncoding
    }
    
    func encode<T: Encodable>(_ object: T?) throws -> String {
        guard let object: T = object else { throw JSONEncoderError.jsonEncoding }
        let data: Data = try self.encode(object)
        guard let string: String = String(data: data, encoding: .utf8) else { throw JSONEncoderError.jsonEncoding }
        return string
    }
}

// MARK: ISO8601
public extension JSONEncoder {
    static var iso8601Format: String {
        return "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    }
    
    static var iso8601: JSONEncoder {
        let encoder: JSONEncoder = JSONEncoder()
        encoder.dateEncodingStrategy = JSONEncoder.DateEncodingStrategy.custom { (date, encoder) in
            var container: SingleValueEncodingContainer = encoder.singleValueContainer()
            let formatter: DateFormatter = kDateFormatter
                .with(calendar: Calendar(identifier: .iso8601))
                .with(locale: Locale(identifier: "en_US_POSIX"))
                .with(timeZone: TimeZone(secondsFromGMT: 0))
            formatter.dateFormat = self.iso8601Format
            let string: String = formatter.string(from: date)
            try container.encode(string)
        }
        return encoder
    }
}
