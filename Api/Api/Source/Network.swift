//
//  Network.swift
//  Api
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: NetworkError
internal enum NetworkError {
    case connectionFailure
    case errorStatusCode(Int)
    case unknown(String?)
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
                              completion: @escaping (Result<Data>) -> Void) -> URLSessionDataTask? {
        guard Reachability.isConnected() else {
            let result: Result<Data> = Result.failure(.connectionFailure)
            completion(result)
            return nil
        }
        
        let sessionDelegate = SessionDelegate(completion)
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
    private var data: Data
    private let successStatusCode: Range<Int>
    private let completion: (Result<Data>) -> Void
    
    init(_ completion: @escaping (Result<Data>) -> Void) {
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
}
