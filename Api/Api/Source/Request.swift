//
//  Request.swift
//  Api
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: ApiError
public enum ApiError: Equatable {
    case connectionFailure
    case incorrectRespoonseFormat
    case errorStatusCode(Int)
    case wrongCredentials
    case unknown(String?)
}

// MARK: ApiTask
public struct ApiTask {
    let task: URLSessionDataTask?
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

public typealias ApiCompletion = (_ data: Data?, _ error: ApiError?) -> Void

// MARK: Request
public struct Request {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    let provider: RequestProvider
    var request: URLRequest
    
    public init(url: URL,
                method: HTTPMethod,
                headers: [String: String] = [:],
                body: Data?,
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
    static func call(_ request: Request,
                     completion: @escaping ApiCompletion)
}

public extension Requestable {
    static func call(_ request: Request,
                     completion: @escaping ApiCompletion) -> ApiTask {
        let networkTask = NetworkProvider.call(request.request) { (result) in
            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, ApiError(error))
            }
        }
        return ApiTask(
            task: networkTask
        )
    }
}

// MARK: RequestProvider
open class RequestProvider {
    private static let queue: DispatchQueue = DispatchQueue(label: "com.limbo.api")
    
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
