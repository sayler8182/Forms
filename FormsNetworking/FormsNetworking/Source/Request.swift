//
//  Request.swift
//  FormsNetworking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsLogger
import Foundation

// MARK: ApiError
public enum ApiError: Equatable {
    case connectionFailure
    case incorrectResponseFormat
    case errorStatusCode(Int)
    case wrongCredentials
    case unknown(String)
}

// MARK: ApiTask
public struct ApiTask {
    public let task: URLSessionDataTask?
    
    public func cancel() {
        self.task?.cancel()
    }
}

public extension ApiError {
    internal init(_ error: NetworkError) {
        switch error {
        case .connectionFailure:
            self = .connectionFailure
        case .errorStatusCode(let statusCode):
            self = .errorStatusCode(statusCode)
        case .unknown(let reason):
            self = .unknown(reason)
        }
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
                method: HTTPMethod,
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
              _ cache: NetworkCache?,
              onCompletion: @escaping ((Data?, ApiError?) -> Void)) -> ApiTask
    @discardableResult
    func call(_ request: Request,
              logger: LoggerProtocol?,
              cache: NetworkCache?,
              onSuccess: @escaping (Data) -> Void,
              onError: @escaping (ApiError) -> Void,
              onCompletion: ((Data?, ApiError?) -> Void)?) -> ApiTask 
    @discardableResult
    func call<T: Parseable>(_ request: Request,
                            logger: LoggerProtocol?,
                            cache: NetworkCache?,
                            parser: ResponseParser,
                            onSuccess: @escaping (T) -> Void,
                            onError: @escaping (ApiError) -> Void,
                            onCompletion: ((T?, ApiError?) -> Void)?) -> ApiTask
}

public extension Requestable {
    @discardableResult
    func call(_ request: Request,
              _ logger: LoggerProtocol? = nil,
              _ cache: NetworkCache? = nil,
              onCompletion: @escaping ((Data?, ApiError?) -> Void)) -> ApiTask {
        let networkTask = NetworkProvider.call(request.request, logger, cache) { (result) in
            switch result {
            case .success(let data):
                onCompletion(data, nil)
            case .failure(let error):
                onCompletion(nil, ApiError(error))
            }
        }
        return ApiTask(
            task: networkTask
        )
    }
    
    @discardableResult
    func call(_ request: Request,
              logger: LoggerProtocol? = nil,
              cache: NetworkCache? = nil,
              onSuccess: @escaping (Data) -> Void,
              onError: @escaping (ApiError) -> Void,
              onCompletion: ((Data?, ApiError?) -> Void)? = nil) -> ApiTask {
        return self.call(request, logger, cache) { (data, error) in
            if let data: Data = data {
                onSuccess(data)
            }
            if let error: ApiError = error {
                onError(error)
            }
            onCompletion?(data, error)
        }
    }
    
    @discardableResult
    func call<T: Parseable>(_ request: Request,
                            logger: LoggerProtocol? = nil,
                            cache: NetworkCache? = nil,
                            parser: ResponseParser,
                            onSuccess: @escaping (T) -> Void,
                            onError: @escaping (ApiError) -> Void,
                            onCompletion: ((T?, ApiError?) -> Void)? = nil) -> ApiTask {
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
