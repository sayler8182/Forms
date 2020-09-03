//
//  SharedContainer.swift
//  Forms
//
//  Created by Konrad on 9/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: SharedContainerProtocol
public protocol SharedContainerProtocol: class {
    var url: URL? { get }
    var jsonURL: URL? { get }
    
    var jsonData: Data? { get set }
    
    init(_ identifier: String)
    func write(data: Data,
               to fileName: String,
               extension _extension: String?)
    func read(from fileName: String,
              extension _extension: String?) -> Data?
}

// MARK: SharedContainerProtocol
extension SharedContainerProtocol {
    func write(data: Data,
               to fileName: String) {
        self.write(
            data: data,
            to: fileName,
            extension: nil)
    }
    func read(from fileName: String) -> Data? {
        return self.read(
            from: fileName,
            extension: nil)
    }
}

// MARK: SharedContainer
public class SharedContainer: SharedContainerProtocol {
    public let url: URL?
    public let jsonURL: URL?
    
    public var jsonData: Data? {
        get { return self.getJSONData() }
        set { self.setJSONData(newValue) }
    }
    
    public required init(_ identifier: String) {
        self.url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)
        self.jsonURL = self.url?
            .appendingPathComponent("shared")
            .appendingPathExtension("json")
    }
    
    public func contents() -> [String] {
        guard let path: String = self.url?.path else { return [] }
        return (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
    }
}

// MARK: I/O
public extension SharedContainer {
    func write(data: Data,
               to fileName: String,
               extension _extension: String? = nil) {
        guard let containerURL: URL = self.url else { return }
        var url: URL = containerURL.appendingPathComponent(fileName)
        if let _extension: String = _extension {
            url = url.appendingPathExtension(_extension)
        }
        try? data.write(to: url)
    }
    
    func read(from fileName: String,
              extension _extension: String? = nil) -> Data? {
        guard let containerURL: URL = self.url else { return nil }
        var url: URL = containerURL.appendingPathComponent(fileName)
        if let _extension: String = _extension {
            url = url.appendingPathExtension(_extension)
        }
        return try? Data(contentsOf: url)
    }
}

// MARK: JSON
private extension SharedContainer {
    private func getJSONData() -> Data? {
        guard let url: URL = self.jsonURL else { return nil }
        return try? Data(contentsOf: url)
    }
    
    private func setJSONData(_ data: Data?) {
        guard let url: URL = self.jsonURL else { return }
        try? data?.write(to: url)
    }
}
