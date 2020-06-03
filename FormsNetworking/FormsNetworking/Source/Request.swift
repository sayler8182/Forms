//
//  Request.swift
//  FormsNetworking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsLogger
import Foundation

// MARK: NetworkError
public enum NetworkError: CustomDebugStringConvertible, Equatable {
    case cancelled
    case connectionFailure
    case incorrectResponseFormat
    case errorStatusCode(Int)
    case unknown(String)
    
    public var isCancelled: Bool {
        return self == .cancelled
    }
    
    public var debugDescription: String {
        switch self {
        case .cancelled: return "Cancelled"
        case .connectionFailure: return "Connection Failure"
        case .incorrectResponseFormat: return "Incorrect response format"
        case .errorStatusCode(let code): return "Error with status code \(code)"
        case .unknown(let reason): return "Unknown \(reason)"
        }
    }
    
    internal init(_ error: Error?) {
        switch error {
        case let error as NSError where error.code == NSURLErrorNotConnectedToInternet:
            self = .connectionFailure
        case let error as NSError where error.code == NSURLErrorCancelled:
            self = .cancelled
        default:
            self = .incorrectResponseFormat
        }
    }
}

// MARK: NetworkTask
public class NetworkTask {
    public let task: URLSessionDataTask?
    
    internal init(task: URLSessionDataTask?) {
        self.task = task
    }
    
    public func cancel() {
        self.task?.cancel()
    }
} 

// MARK: Request
public struct Request {
    public let url: URL
    public let method: HTTPMethod
    public let headers: [String: String]
    public let body: Data?
    public let provider: RequestProvider
    public var request: URLRequest
    
    public init(url: URL,
                method: HTTPMethod = .GET,
                headers: [String: String] = [:],
                body: Data? = nil,
                provider: RequestProvider? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.provider = provider ?? RequestProvider()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        self.request = request
        self.provider.process(request: &self)
    }
}

// MARK: Requestable
public protocol Requestable {
    @discardableResult
    func call(_ request: Request,
              _ logger: LoggerProtocol?,
              _ cache: NetworkCacheProtocol?,
              onCompletion: @escaping ((Data?, NetworkError?) -> Void)) -> NetworkTask
    @discardableResult
    func call(_ request: Request,
              logger: LoggerProtocol?,
              cache: NetworkCacheProtocol?,
              onSuccess: @escaping (Data) -> Void,
              onError: @escaping (NetworkError) -> Void,
              onCompletion: ((Data?, NetworkError?) -> Void)?) -> NetworkTask 
    @discardableResult
    func call<T: Parseable>(_ request: Request,
                            logger: LoggerProtocol?,
                            cache: NetworkCacheProtocol?,
                            parser: ResponseParser,
                            onSuccess: @escaping (T) -> Void,
                            onError: @escaping (NetworkError) -> Void,
                            onCompletion: ((T?, NetworkError?) -> Void)?) -> NetworkTask
}

public extension Requestable {
    @discardableResult
    func call(_ request: Request,
              _ logger: LoggerProtocol? = nil,
              _ cache: NetworkCacheProtocol? = nil,
              onCompletion: @escaping ((Data?, NetworkError?) -> Void)) -> NetworkTask {
        let logger: LoggerProtocol? = logger ?? Injector.main.resolveOrDefault("FormsNetworking")
        let cache: NetworkCacheProtocol? = cache ?? Injector.main.resolveOrDefault("FormsNetworking")
        let networkTask = NetworkProvider.call(request.request, logger, cache) { (result) in
            switch result {
            case .success(let data):
                onCompletion(data, nil)
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
        return NetworkTask(
            task: networkTask)
    }
    
    @discardableResult
    func call(_ request: Request,
              logger: LoggerProtocol? = nil,
              cache: NetworkCacheProtocol? = nil,
              onSuccess: @escaping (Data) -> Void,
              onError: @escaping (NetworkError) -> Void,
              onCompletion: ((Data?, NetworkError?) -> Void)? = nil) -> NetworkTask {
        return self.call(request, logger, cache) { (data, error) in
            if let data: Data = data {
                onSuccess(data)
            }
            if let error: NetworkError = error {
                onError(error)
            }
            onCompletion?(data, error)
        }
    }
    
    @discardableResult
    func call<T: Parseable>(_ request: Request,
                            logger: LoggerProtocol? = nil,
                            cache: NetworkCacheProtocol? = nil,
                            parser: ResponseParser,
                            onSuccess: @escaping (T) -> Void,
                            onError: @escaping (NetworkError) -> Void,
                            onCompletion: ((T?, NetworkError?) -> Void)? = nil) -> NetworkTask {
        return self.call(request, logger, cache) { (data, error) in
            parser.parse(
                data: data,
                error: error,
                onSuccess: onSuccess,
                onError: onError,
                onCompletion: onCompletion)
        }
    }
}

// MARK: RequestProvider
open class RequestProvider {
    private static let queue: DispatchQueue = DispatchQueue(label: "com.limbo.api")
    
    public init() { }
    
    internal func process(request: inout Request) {
        RequestProvider.queue.sync {
            self.preProcess(&request)
            self.setHeaders(&request)
        }
    }
    
    open func preProcess(_ request: inout Request) {
        // HOOK
    }
    
    open func setHeaders(_ request: inout Request) {
        let headers = request.headers
        request.request.allHTTPHeaderFields = headers
    }
}
