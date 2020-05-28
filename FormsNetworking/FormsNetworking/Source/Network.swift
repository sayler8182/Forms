//
//  Network.swift
//  FormsNetworking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsLogger
import Foundation

// MARK: NetworkError
internal enum NetworkError {
    case connectionFailure
    case errorStatusCode(Int)
    case unknown(String)
}

// MARK: Result
internal enum Result<T> {
    case success(T)
    case failure(NetworkError)
}

// MARK: HTTPMethod
public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

// MARK: NetworkProvider
internal enum NetworkProvider {
    internal static func call(_ request: URLRequest,
                              _ logger: LoggerProtocol?,
                              _ cache: NetworkCache?,
                              completion: @escaping (Result<Data>) -> Void) -> URLSessionDataTask? {
        let hash: Any = request.hashValue
        if let cache: NetworkCache = cache,
            let data: Data = try? cache.read(hash: hash) {
            let result: Result<Data> = Result.success(data)
            completion(result)
            return nil
        }
        
        guard Reachability.isConnected() else {
            let result: Result<Data> = Result.failure(.connectionFailure)
            completion(result)
            return nil
        }
        
        let sessionDelegate = SessionDelegate(hash, logger, cache, completion)
        sessionDelegate.log(request)
        let sessionConfiguration = NetworkProvider.sessionConfiguration()
        let session = URLSession(
            configuration: sessionConfiguration,
            delegate: sessionDelegate,
            delegateQueue: nil)
        let task: URLSessionDataTask = session.dataTask(with: request)
        task.resume()
        session.finishTasksAndInvalidate()
        return task
    }
    
    private static func sessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.httpShouldSetCookies = true
        configuration.timeoutIntervalForRequest = 30
        return configuration
    }
}

// MARK: SessionDelegate
internal class SessionDelegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    private let requestHash: Any
    private let logger: LoggerProtocol?
    private let cache: NetworkCache?
    private var data: Data
    private let successStatusCode: Range<Int>
    private let completion: (Result<Data>) -> Void
    
    init(_ requestHash: Any,
         _ logger: LoggerProtocol?,
         _ cache: NetworkCache?,
         _ completion: @escaping (Result<Data>) -> Void) {
        self.requestHash = requestHash
        self.logger = logger
        self.cache = cache
        self.data = Data()
        self.successStatusCode = 200..<300
        self.completion = completion
        super.init()
    }
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
    }
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        guard error == nil,
            let response = task.response as? HTTPURLResponse else {
                let result: Result<Data> = Result.failure(.connectionFailure)
                self.completion(result)
                return
        }
         
        guard self.successStatusCode ~= response.statusCode else {
            let result: Result<Data> = Result.failure(.errorStatusCode(response.statusCode))
            self.completion(result)
            return
        }
        
        self.log(response, self.data)
        try? self.cache?.write(hash: self.requestHash, data: self.data)
        let result: Result<Data> = Result.success(self.data)
        self.completion(result)
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        self.data.append(data)
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        SSLPinning.validate(
            session,
            didReceive: challenge,
            completionHandler: completionHandler)
    }
    
    fileprivate func log(_ request: URLRequest) {
        guard let logger: LoggerProtocol = self.logger else { return }
        var string: String = ""
        string += "\nREQUEST"
        string += "\n" + (request.url?.absoluteString ?? "")
        if let headers = request.allHTTPHeaderFields,
            !headers.isEmpty {
            string += "\n\t" + "HEADERS:"
            for header in headers {
                string += "\n\t\t" + header.key + ": " + header.value
            }
        }
        if let body = request.httpBody,
            !body.isEmpty {
            string += "\n\t" + "BODY:"
            string += "" + self.dataToString(data: body).replacingOccurrences(of: "\n", with: "\n\t")
        }
        logger.log(string)
    }
    
    fileprivate func log(_ response: HTTPURLResponse,
                         _ body: Data) {
        guard let logger: LoggerProtocol = self.logger else { return }
        var string: String = ""
        string += "\nRESPONSE"
        string += "\n" + (response.url?.absoluteString ?? "")
        let headers = response.allHeaderFields
        if !headers.isEmpty {
            string += "\n\t" + "HEADERS:"
            for header in headers {
                string += "\n\t\t" + header.key.description + ": " + "\(header.value)"
            }
        }
        if !body.isEmpty {
            string += "\n\t" + "BODY:"
            string += "\n\t" + self.dataToString(data: body).replacingOccurrences(of: "\n", with: "\n\t")
        }
        logger.log(string)
    }
    
    private func dataToString(data: Data) -> String {
        var string: String = ""
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            string = String(data: prettyData, encoding: .utf8) ?? ""
        } catch let error {
            string = error.localizedDescription
        }
        return string
    }
}
