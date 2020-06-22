//
//  NetworkMethod.swift
//  FormsNetworking
//
//  Created by Konrad on 6/22/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsLogger
import Foundation

// MARK: AssociatedKeys
private enum AssociatedKeys {
    static var sessionKey: UInt8 = 0
    static var loggerKey: UInt8 = 0
    static var cacheKey: UInt8 = 0
}

// MARK: NetworkMethod
public protocol NetworkMethod: class {
    var session: NetworkSessionProtocol? { get set }
    var logger: Logger? { get set }
    var cache: NetworkCache? { get set }
    var provider: NetworkProviderProtocol { get }
    var content: NetworkMethodContent? { get }
    var method: HTTPMethod { get }
    var url: URL! { get }
    var interceptor: NetworkRequestInterceptor? { get }
    var parser: NetworkResponseParser? { get }
    var request: NetworkRequest { get }
    var isCached: Bool { get }
}

public extension NetworkMethod {
    var session: NetworkSessionProtocol? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.sessionKey) as? NetworkSessionProtocol }
        set { objc_setAssociatedObject(self, &AssociatedKeys.sessionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    var logger: Logger? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.loggerKey) as? Logger }
        set { objc_setAssociatedObject(self, &AssociatedKeys.loggerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    var cache: NetworkCache? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.cacheKey) as? NetworkCache }
        set { objc_setAssociatedObject(self, &AssociatedKeys.cacheKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    var provider: NetworkProviderProtocol {
        let _provider: NetworkProviderProtocol? = Injector.main.resolveOrDefault("FormsNetworking")
        let provider: NetworkProviderProtocol = _provider ?? NetworkProvider()
        return provider
            .with(session: self.session)
            .with(logger: self.logger)
            .with(cache: self.cache)
    }
    var content: NetworkMethodContent? {
        return nil
    }
    var method: HTTPMethod {
        return .GET
    }
    var interceptor: NetworkRequestInterceptor? {
        return nil
    }
    var parser: NetworkResponseParser? {
        return NetworkResponseParser()
    }
    var request: NetworkRequest {
        return NetworkRequest(url: self.url)
            .with(method: self.method)
            .with(headers: self.content?.headers)
            .with(body: self.content?.body)
            .with(interceptor: self.interceptor)
    }
    var isCached: Bool {
        self.provider.isCached(request: self.request)
    }
    
    @discardableResult
    func call(onProgress: NetworkOnProgress? = nil,
              onSuccess: NetworkOnSuccess? = nil,
              onError: NetworkOnError? = nil,
              onCompletion: NetworkOnCompletion? = nil) -> NetworkTask {
        return self.provider.call(
            request: self.request,
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
    
    @discardableResult
    func call<T: Parseable>(onProgress: NetworkOnProgress? = nil,
                            onSuccess: NetworkOnGenericSuccess<T>? = nil,
                            onError: NetworkOnError? = nil,
                            onCompletion: NetworkOnGenericCompletion<T>? = nil) -> NetworkTask {
        return self.provider.call(
            request: self.request,
            parser: self.parser,
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
}

// MARK: Builder
public extension NetworkMethod {
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

// MARK: NetworkMethodContent
public protocol NetworkMethodContent {
    var body: Data? { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

public extension NetworkMethodContent {
    var body: Data? {
        guard let parameters = self.parameters else { return nil }
        return try? JSONSerialization.data(withJSONObject: parameters, options: [])
    }
    var headers: [String: String]? { nil }
}
