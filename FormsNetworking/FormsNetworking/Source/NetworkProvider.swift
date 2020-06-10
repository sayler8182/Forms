//
//  NetworkProvider.swift
//  FormsNetworking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsLogger
import Foundation

public typealias NetworkOnProgress = (_ size: Int64, _ totalSize: Int64, _ progress: Double) -> Void
public typealias NetworkOnSuccess = (_ data: Data) -> Void
public typealias NetworkOnGenericSuccess<T> = (T) -> Void
public typealias NetworkOnError = (_ error: NetworkError) -> Void
public typealias NetworkOnCompletion = (_ data: Data?, _ error: NetworkError?) -> Void
public typealias NetworkOnGenericCompletion<T> = (T?, NetworkError?) -> Void

// MARK: NetworkError
public enum NetworkError: CustomDebugStringConvertible, Equatable {
    case cancelled
    case connectionFailure
    case emptyResponse
    case incorrectResponseFormat
    case errorStatusCode(Int)
    case unknown(String)
    
    public var isCancelled: Bool {
        return self == .cancelled
    }
    
    public var debugDescription: String {
        switch self {
        case .cancelled: return "Cancelled"
        case .connectionFailure: return "Connection failure"
        case .emptyResponse: return "Empty response"
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
    
    internal init(_ task: URLSessionDataTask?) {
        self.task = task
    }
    
    public func cancel() {
        self.task?.cancel()
    }
} 

// MARK: NetworkRequest
public class NetworkRequest {
    public let url: URL
    
    public var method: HTTPMethod?
    public var headers: [String: String]?
    public var body: Data?
    public var interceptor: NetworkRequestInterceptor?
    public var request: URLRequest?
    
    public init(url: URL) {
        self.url = url
    }
    
    public func build() -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = self.method?.rawValue
        request.httpBody = self.body
        self.interceptor?.process(request: self)
        self.request = request
        return request
    }
}
public extension NetworkRequest {
    func with(method: HTTPMethod?) -> Self {
        self.method = method
        return self
    }
    func with(headers: [String: String]?) -> Self {
        self.headers = headers
        return self
    }
    func with(body: Data?) -> Self {
        self.body = body
        return self
    }
    func with(interceptor: NetworkRequestInterceptor?) -> Self {
        self.interceptor = interceptor
        return self
    }
}

// MARK: NetworkMethod
open class NetworkMethod {
    public var logger: Logger?
    public var cache: NetworkCache?

    public init() { }
    
    public var provider: NetworkProviderProtocol = {
        let provider: NetworkProviderProtocol? = Injector.main.resolveOrDefault("FormsNetworking")
        return provider ?? NetworkProvider()
    }()
    
    public func with(logger: Logger?) -> Self {
        self.logger = logger
        return self
    }
    
    public func with(cache: NetworkCache?) -> Self {
        self.cache = cache
        return self
    }
}

// MARK: NetworkProviderProtocol
public protocol NetworkProviderProtocol {
    @discardableResult
    func call(request: NetworkRequest,
              onProgress: NetworkOnProgress?,
              onSuccess: @escaping NetworkOnSuccess,
              onError: @escaping NetworkOnError,
              onCompletion: NetworkOnCompletion?) -> NetworkTask
    @discardableResult
    func call<T: Parseable>(request: NetworkRequest,
                            parser: NetworkResponseParser?,
                            onProgress: NetworkOnProgress?,
                            onSuccess: @escaping NetworkOnGenericSuccess<T>,
                            onError: @escaping NetworkOnError,
                            onCompletion: NetworkOnGenericCompletion<T>?) -> NetworkTask
}
public extension NetworkProviderProtocol {
    @discardableResult
    func call(request: NetworkRequest,
              onSuccess: @escaping NetworkOnSuccess,
              onError: @escaping NetworkOnError,
              onCompletion: NetworkOnCompletion?) -> NetworkTask {
        return self.call(
            request: request,
            onProgress: nil,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
    @discardableResult
    func call(request: NetworkRequest,
              onProgress: NetworkOnProgress?,
              onSuccess: @escaping NetworkOnSuccess,
              onError: @escaping NetworkOnError) -> NetworkTask {
        return self.call(
            request: request,
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: nil)
    }
    @discardableResult
    func call<T: Parseable>(request: NetworkRequest,
                            parser: NetworkResponseParser?,
                            onSuccess: @escaping NetworkOnGenericSuccess<T>,
                            onError: @escaping NetworkOnError) -> NetworkTask {
        return self.call(
            request: request,
            parser: parser,
            onProgress: nil,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: nil)
    }
    @discardableResult
    func call<T: Parseable>(request: NetworkRequest,
                            parser: NetworkResponseParser?,
                            onProgress: NetworkOnProgress?,
                            onSuccess: @escaping NetworkOnGenericSuccess<T>,
                            onError: @escaping NetworkOnError) -> NetworkTask {
        return self.call(
            request: request,
            parser: parser,
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: nil)
    }
    @discardableResult
    func call<T: Parseable>(request: NetworkRequest,
                            parser: NetworkResponseParser?,
                            onSuccess: @escaping NetworkOnGenericSuccess<T>,
                            onError: @escaping NetworkOnError,
                            onCompletion: NetworkOnGenericCompletion<T>?) -> NetworkTask {
        return self.call(
            request: request,
            parser: parser,
            onProgress: nil,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
}

// MARK: NetworkProvider
open class NetworkProvider: NetworkProviderProtocol {
    private let session: NetworkSessionProtocol?
    private let logger: Logger?
    private let cache: NetworkCache?
    
    private let queue = DispatchQueue.global(qos: .background)
    
    public init(session: NetworkSessionProtocol? = nil,
                logger: Logger? = nil,
                cache: NetworkCache? = nil) {
        self.session = session
        self.logger = logger
        self.cache = cache
    }
    
    @discardableResult
    public func call(request: NetworkRequest,
                     onProgress: NetworkOnProgress? = nil,
                     onSuccess: @escaping NetworkOnSuccess,
                     onError: @escaping NetworkOnError,
                     onCompletion: NetworkOnCompletion? = nil) -> NetworkTask {
        return self.call(
            request: request,
            onProgress: onProgress,
            onCompletion: { (data, error) in
                if let error: NetworkError = error {
                    onError(error)
                } else if let data: Data = data {
                    onSuccess(data)
                }
                onCompletion?(data, error)
        })
    }
    
    @discardableResult
    public func call<T: Parseable>(request: NetworkRequest,
                                   parser: NetworkResponseParser?,
                                   onProgress: NetworkOnProgress? = nil,
                                   onSuccess: @escaping NetworkOnGenericSuccess<T>,
                                   onError: @escaping NetworkOnError,
                                   onCompletion: NetworkOnGenericCompletion<T>? = nil) -> NetworkTask {
        return self.call(
            request: request,
            onProgress: onProgress) { (data: Data?, error: NetworkError?) in
                parser?.parse(
                    data: data,
                    error: error,
                    onSuccess: onSuccess,
                    onError: onError,
                    onCompletion: onCompletion)
        }
    }
    
    @discardableResult
    private func call(request: NetworkRequest,
                      onProgress: NetworkOnProgress?,
                      onCompletion: @escaping NetworkOnCompletion) -> NetworkTask {
        let session: NetworkSessionProtocol? = self.session ?? Injector.main.resolveOrDefault("FormsNetworking") ?? NetworkSession()
        let logger: Logger? = self.logger ?? Injector.main.resolveOrDefault("FormsNetworking")
        let cache: NetworkCache? = self.cache ?? Injector.main.resolveOrDefault("FormsNetworking")
        let request: URLRequest = request.build()
        let task: URLSessionDataTask? = session?.call(
            request: request,
            logger: logger,
            cache: cache,
            onProgress: onProgress,
            onCompletion: onCompletion)
        return NetworkTask(task)
    }
}

// MARK: NetworkRequestInterceptor
open class NetworkRequestInterceptor {
    private static let queue: DispatchQueue = DispatchQueue(label: "com.Fimbo.Network")
    
    public init() { }
    
    internal func process(request: NetworkRequest) {
        NetworkRequestInterceptor.queue.sync {
            self.preProcess(request)
            self.setHeaders(request)
        }
    }
    
    open func preProcess(_ request: NetworkRequest) {
        // HOOK
    }
    
    open func setHeaders(_ request: NetworkRequest) {
        // HOOK
    }
}
