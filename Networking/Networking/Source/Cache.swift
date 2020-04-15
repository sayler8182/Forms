//
//  Cache.swift
//  Networking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

public class NetworkCache {
    private let fileManager = FileManager.default
    private let directory: URL = FileManager.default.temporaryDirectory.appendingPathComponent("networking_cache")
    private let ttl: TimeInterval
    
    public init(ttl: TimeInterval) {
        self.ttl = ttl
        try? self.fileManager.createDirectory(at: self.directory, withIntermediateDirectories: false, attributes: .none)
    }
    
    public func write(hash: Any,
                      data: Data) throws {
        let expirationDate: Int64 = Int64(Date().timeIntervalSince1970 + self.ttl)
        let url: URL = self.directory.appendingPathComponent("_\(hash).\(expirationDate).cache")
        try? self.fileManager.removeItem(at: url)
        try data.write(to: url)
        print("write:", url.absoluteString)
    }
    
    public func read(hash: Any) throws -> Data? {
        try self.clean()
        guard let url: URL = try self.fileManager.contentsOfDirectory(
            at: self.directory,
            includingPropertiesForKeys: nil,
            options: .includesDirectoriesPostOrder)
            .first(where: { $0.absoluteString.contains("_\(hash).") }) else { return nil }
        print("read:", url.absoluteString)
        return try Data(contentsOf: url)
    }
    
    public func reset() throws {
        try self.fileManager.removeItem(at: self.directory)
        try self.fileManager.createDirectory(at: self.directory, withIntermediateDirectories: false, attributes: .none)
    }
    
    public func clean() throws {
        let now: TimeInterval = Date().timeIntervalSince1970
        let urls: [URL] = try self.fileManager.contentsOfDirectory(
            at: self.directory,
            includingPropertiesForKeys: nil,
            options: .includesDirectoriesPostOrder)
        for url in urls {
            let string: String = url.absoluteString.components(separatedBy: ".")[1]
            let expirationDate: TimeInterval = TimeInterval(string) ?? 0
            if now >= expirationDate {
                try? self.fileManager.removeItem(at: url)
            }
        }
    }
}
