//
//  URLCoder.swift
//  FormsUtils
//
//  Created by Konrad on 9/3/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: URLCoder
public class URLCoder {
    public init() { }
    
    public func encode(url: URL,
                       parameters: [String: Any?]?) -> URL {
        do {
            let parameters: [String: Any] = parameters?.compactMapValues { $0 } ?? [:]
            let data: Data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            guard let string: String = String(data: data, encoding: .utf8) else { return url }
            let base64: String = string.toBase64()
            return url.absoluteString.appending(base64).url
        } catch {
            return url
        }
    }
    
    public func decode(url: URL?) -> [String: Any] {
        do {
            guard let path: String = url?.absoluteString else { return [:] }
            guard let base64: String = path.components(separatedBy: "/").last else { return [:] }
            guard let string: String = base64.fromBase64() else { return [:] }
            let data: Data = string.data
            let object: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let parameters: [String: Any] = object as? [String: Any] else { return [:] }
            return parameters
        } catch {
            return [:]
        }
    }
    
    public func encode<T: Encodable>(url: URL,
                                     object: T?) -> URL {
        do {
            let data: Data = try JSONEncoder.iso8601.encode(object)
            guard let string: String = String(data: data, encoding: .utf8) else { return url }
            let base64: String = string.toBase64()
            return url.absoluteString.appending(base64).url
        } catch {
            return url
        }
    }
    
    public func decode<T: Decodable>(url: URL?) -> T? {
        do {
            guard let path: String = url?.absoluteString else { return nil }
            guard let base64: String = path.components(separatedBy: "/").last else { return nil }
            guard let string: String = base64.fromBase64() else { return nil }
            let data: Data = string.data
            let object: Any = try JSONDecoder.iso8601.decode(T.self, from: data)
            guard let parameters: T = object as? T else { return nil }
            return parameters
        } catch {
            return nil
        }
    }
}
