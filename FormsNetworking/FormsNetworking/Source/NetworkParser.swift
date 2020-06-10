//
//  NetworkParser.swift
//  FormsNetworking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Parseable
public protocol Parseable {
    init(with data: Data) throws
}

public extension Parseable where Self: Codable {
    func asData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

public extension Parseable where Self: Decodable {
    init(with data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

// MARK: NetworkResponseParser
open class NetworkResponseParser {
    public init() { }
     
    open func parse<T: Parseable>(data: Data?,
                                  error: NetworkError?,
                                  onSuccess: NetworkOnGenericSuccess<T>,
                                  onError: NetworkOnError,
                                  onCompletion: NetworkOnGenericCompletion<T>? = nil) {
        guard let data: Data = data else {
            let error: NetworkError = error ?? NetworkError.incorrectResponseFormat
            onError(error)
            onCompletion?(nil, error)
            return
        }
        if let error = self.parseError(data: data) {
            onError(error)
            onCompletion?(nil, error)
        }
        guard let object: T = self.map(data: data) else {
            let error: NetworkError = NetworkError.incorrectResponseFormat
            onError(error)
            onCompletion?(nil, error)
            return
        }
        onSuccess(object)
        onCompletion?(object, error)
    }
    
    open func parseError(data: Data) -> NetworkError? {
        return nil
    }
    
    open func map<T: Parseable>(data: Data) -> T? {
        return try? T(with: data)
    }
}
