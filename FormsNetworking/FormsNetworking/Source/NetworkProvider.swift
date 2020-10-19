//
//  NetworkProvider.swift
//  FormsNetworking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsLogger
import FormsUtils
import Foundation

public typealias NetworkOnProgress = (_ size: Int64, _ totalSize: Int64, _ progress: Double) -> Void
public typealias NetworkOnSuccess = (_ data: Data) -> Void
public typealias NetworkOnGenericSuccess<T> = (T) -> Void
public typealias NetworkOnError = (_ error: NetworkError) -> Void
public typealias NetworkOnCompletion = (_ data: Data?, _ error: NetworkError?) -> Void
public typealias NetworkOnGenericCompletion<T> = (T?, _ error: NetworkError?) -> Void

// MARK: NetworkError
public enum NetworkError: Error, CustomDebugStringConvertible, Equatable {
    case cancelled
    case connectionFailure
    case emptyResponse
    case incorrectResponseFormat
    case incorrectRequestFormat
    case errorStatusCode(Int)
    case error(String)
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
        case .incorrectRequestFormat: return "Incorrect request format"
        case .errorStatusCode(let code): return "Error with status code \(code)"
        case .error(let reason): return reason
        case .unknown(let reason): return "Unknown \(reason)"
        }
    }
    
    public init?(_ error: Error?) {
        guard let error: Error = error else { return nil }
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
    private let queue: DispatchQueue = DispatchQueue.global()
    
    private var _task: URLSessionDataTask? = nil
    public var task: URLSessionDataTask? {
        get { return self.queue.sync { self._task } }
        set { self.queue.sync {
            self._task = newValue
            if self._isCancelled {
                self._task?.cancel()
            }
        } }
    }
    
    private var _isCancelled: Bool = false
    public var isCancelled: Bool {
        return self.queue.sync {
            return self._isCancelled || self.task?.state == .canceling
        }
    }
    
    public init() { }
    
    public func cancel() {
        self.queue.sync {
            self._isCancelled = true
            self.task?.cancel()
        }
    }
} 

// MARK: NetworkRequest
public class NetworkRequest {
    public let url: URL
    
    public var networkMethod: NetworkMethod?
    public var method: HTTPMethod?
    public var headers: [String: String]?
    public var body: Data?
    public var requestInterceptor: NetworkRequestInterceptor?
    public var responseInterceptor: NetworkResponseInterceptor?
    public var request: URLRequest?
    
    public init(url: URL) {
        self.url = url
    }
    
    public func build() -> URLRequest! {
        var request = URLRequest(url: self.url)
        request.allHTTPHeaderFields = self.headers
        request.httpMethod = self.method?.rawValue
        request.httpBody = self.body
        self.request = request
        self.requestInterceptor?.process(request: self)
        return self.request
    }
}
public extension NetworkRequest {
    func with(networkMethod: NetworkMethod) -> Self {
        self.networkMethod = networkMethod
        return self
    }
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
    func with(requestInterceptor: NetworkRequestInterceptor?) -> Self {
        self.requestInterceptor = requestInterceptor
        return self
    }
    func with(responseInterceptor: NetworkResponseInterceptor?) -> Self {
        self.responseInterceptor = responseInterceptor
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
    
    func isCached(request: NetworkRequest) -> Bool {
        let request: URLRequest = request.build()
        let hash: Any = request.hashValue
        return (try? self.cache?.isCached(hash: hash)) ?? false
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
    
    @discardableResult
    private func call(request: NetworkRequest,
                      onProgress: NetworkOnProgress?,
                      onCompletion: @escaping NetworkOnCompletion) -> NetworkTask {
        let session: NetworkSessionProtocol? = (self.session?.isEnabled == true ? self.session : nil) ?? Injector.main.resolveOrDefault("FormsNetworking") ?? NetworkSession()
        let logger: Logger? = self.logger ?? Injector.main.resolveOrDefault("FormsNetworking")
        let cache: NetworkCache? = self.cache ?? Injector.main.resolveOrDefault("FormsNetworking")
        let urlRequest: URLRequest = request.build()
        let networkTask: NetworkTask = NetworkTask()
        DispatchQueue.global().async {
            let task: URLSessionDataTask? = session?.call(
                request: urlRequest,
                logger: logger,
                cache: cache,
                onProgress: onProgress,
                onCompletion: { (response: URLResponse?, data: Data?, error: NetworkError?) in
                    guard let interceptor: NetworkResponseInterceptor = request.responseInterceptor else {
                        onCompletion(data, error)
                        return
                    }
                    interceptor.postProcess(
                        response: response,
                        data: data,
                        error: error,
                        onCompletion: onCompletion)
                })
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

// MARK: NetworkResponseInterceptor
open class NetworkResponseInterceptor {
    public init() { }
    
    open func postProcess(response: URLResponse?,
                          data: Data?,
                          error: NetworkError?,
                          onCompletion: @escaping NetworkOnCompletion) {
        onCompletion(data, error)
    }
}
