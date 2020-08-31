//
//  JSONDecoder.swift
//  FormsUtils
//
//  Created by Konrad on 8/31/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

private let kDateFormatter: DateFormatter = DateFormatter()
    
// MARK: JSONDecoder
public extension JSONDecoder {
    enum JSONDecoderError: String, Error {
        case jsonDecoding
        case dateDecoding
    }
    
    func decode<T: Decodable>(_ type: T.Type,
                              from string: String) throws -> T {
        guard let data: Data = string.data(using: .utf8) else { throw JSONDecoderError.jsonDecoding }
        return try self.decode(T.self, from: data)
    } 
}

// MARK: ISO8601
public extension JSONDecoder {
    static var iso8601Formats: [String] {
        return [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        ]
    }
    
    static var iso8601: JSONDecoder {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom { (decoder) -> Date in
            let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
            let string: String = try container.decode(String.self)
            let formatter: DateFormatter = kDateFormatter
                .with(calendar: Calendar(identifier: .iso8601))
                .with(locale: Locale(identifier: "en_US_POSIX"))
                .with(timeZone: TimeZone(secondsFromGMT: 0))
            for format in self.iso8601Formats {
                formatter.dateFormat = format
                guard let date: Date = formatter.date(from: string) else { continue }
                return date
            }
            throw JSONDecoderError.dateDecoding
        }
        return decoder
    }
}
