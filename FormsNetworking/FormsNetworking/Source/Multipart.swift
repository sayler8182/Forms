//
//  Multipart.swift
//  FormsNetworking
//
//  Created by Konrad on 6/1/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Multipartable
public protocol Multipartable {
    var multiparts: [MultipartItem] { get }
}

// MARK: [Multipartable]
extension Array where Element == Multipartable {
    var multiparts: [MultipartItem] {
        return self.flatMap { $0.multiparts }
    }
}

// MARK: MultipartDescriptionable
public protocol MultipartDescriptionable {
    var multipartDescription: Data? { get }
}

// MARK: MultipartItem
public struct MultipartItem: MultipartDescriptionable {
    let disposition: MultipartContentDisposition
    let type: ContentType?
    let body: Data?
    
    public var multipartDescription: Data? {
        return [
            self.disposition.multipartDescription,
            self.type?.multipartDescription,
            self.body
            ]
            .compactMap { $0 }
            .reduce(into: Data(), { $0 += $1 })
    }
    
    public init(disposition: MultipartContentDisposition,
                type: ContentType?,
                body: Data?) {
        self.disposition = disposition
        self.type = type
        self.body = body
    }
         
    public init(name: String,
                value: String) {
        self.disposition = MultipartContentDisposition(name: name, filename: nil)
        self.type = nil
        self.body = value.data(using: .utf8)
    }
    
    public init?(name: String,
                 value: String?) {
        guard let value: String = value else { return nil }
        self.init(name: name, value: value)
    }
}

// MARK: MultipartContentDisposition
public struct MultipartContentDisposition: MultipartDescriptionable {
    public let name: String?
    public let filename: String?
    
    public var multipartDescription: Data? {
        var string: String = ""
        string += "Content-Disposition: form-data"
        if let name: String = self.name {
            string += "; name=\"\(name)\""
        }
        if let filename: String = self.filename {
            string += "; filename=\"\(filename)\""
        }
        string += "\r\n"
        return string.data(using: .utf8)
    }
}

// MARK: ContentType
extension ContentType: MultipartDescriptionable {
    public var multipartDescription: Data? {
        let string: String = "Content-Type: \(self.rawValue) \r\n"
        return string.data(using: .utf8)
    }
}