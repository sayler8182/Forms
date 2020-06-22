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
public enum NetworkError: Error, CustomDebugStringConvertible, Equatable {
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
    public var task: URLSessionDataTask? {
        didSet { self.updateTask() }
    }
    
    private var _isCancelled: Bool = false
    public var isCancelled: Bool {
        return self._isCancelled || self.task?.state == .canceling
    }
    
    public func cancel() {
        self._isCancelled = true
        self.task?.cancel()
    }
    
    private func updateTask() {
        guard self._isCancelled else { return }
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

// MARK: NetworkProviderProtocol
public protocol NetworkProviderProtocol: class {
    var session: NetworkSessionProtocol? { get set }
    var logger: Logger? { get set }
    var cache: NetworkCache? { get set }
    
    @discardableResult
    func call(request: NetworkRequest,
              onProgress: NetworkOnProgress?,
              onSuccess: NetworkOnSuccess?,
              onError: NetworkOnError?,
              onCompletion: NetworkOnCompletion?) -> NetworkTask
    @discardableResult
    func call<T: Parseable>(request: NetworkRequest,
                            parser: NetworkResponseParser?,
                            onProgress: NetworkOnProgress?,
                            onSuccess: NetworkOnGenericSuccess<T>?,
                            onError: NetworkOnError?,
                            onCompletion: NetworkOnGenericCompletion<T>?) -> NetworkTask
    func isCached(request: NetworkRequest) -> Bool
}

public extension NetworkProviderProtocol {
    func with(session: NetworkSessionProtocol?) -> Self {
        self.session = session
        return self
    }
    func with(logger: Logger?) -> Self {
        self.logger = logger
        return self
    }
    func with(cache: NetworkCache?) -> Self {
        self.cache = cache
        return self
    }
}

// MARK: NetworkProvider
open class NetworkProvider: NetworkProviderProtocol {
    public var session: NetworkSessionProtocol?
    public var logger: Logger?
    public var cache: NetworkCache?
    
    private let queue = DispatchQueue.global(qos: .background)
    
    public init() { }
    
    @discardableResult
    public func call(request: NetworkRequest,
                     onProgress: NetworkOnProgress? = nil,
                     onSuccess: NetworkOnSuccess? = nil,
                     onError: NetworkOnError? = nil,
                     onCompletion: NetworkOnCompletion? = nil) -> NetworkTask {
        return self.call(
            request: request,
            onProgress: onProgress,
            onCompletion: { (data, error) in
                if let error: NetworkError = error {
                    onError?(error)
                } else if let data: Data = data {
                    onSuccess?(data)
                }
                onCompletion?(data, error)
        })
    }
    
    @discardableResult
    public func call<T: Parseable>(request: NetworkRequest,
                                   parser: NetworkResponseParser? = nil,
                                   onProgress: NetworkOnProgress? = nil,
                                   onSuccess: NetworkOnGenericSuccess<T>? = nil,
                                   onError: NetworkOnError? = nil,
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
    
    public func isCached(request: NetworkRequest) -> Bool {
        let request: URLRequest = request.build()
        let hash: Any = request.hashValue
        return (try? self.cache?.isCached(hash: hash)) ?? false
    }
    
    @discardableResult
    private func call(request: NetworkRequest,
                      onProgress: NetworkOnProgress?,
                      onCompletion: @escaping NetworkOnCompletion) -> NetworkTask {
        let session: NetworkSessionProtocol? = self.session ?? Injector.main.resolveOrDefault("FormsNetworking") ?? NetworkSession()
        let logger: Logger? = self.logger ?? Injector.main.resolveOrDefault("FormsNetworking")
        let cache: NetworkCache? = self.cache ?? Injector.main.resolveOrDefault("FormsNetworking")
        let request: URLRequest = request.build()
        let networkTask: NetworkTask = NetworkTask()
        DispatchQueue.global().async {
            let task: URLSessionDataTask? = session?.call(
                request: request,
                logger: logger,
                cache: cache,
                onProgress: onProgress,
                onCompletion: onCompletion)
            networkTask.task = task
        }
        return networkTask
    }
}

// MARK: NetworkRequestInterceptor
open class NetworkRequestInterceptor {
    public init() { }
    
    internal func process(request: NetworkRequest) {
        self.preProcess(request)
        self.setHeaders(request)
    }
    
    open func preProcess(_ request: NetworkRequest) {
        // HOOK
    }
    
    open func setHeaders(_ request: NetworkRequest) {
        // HOOK
    }
}
