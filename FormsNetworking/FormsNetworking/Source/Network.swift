//
//  Network.swift
//  FormsNetworking
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsLogger
import Foundation

// MARK: ContentType {
public enum ContentType: String {
    case jpeg = "image/jpeg"
    case jpg = "image/jpg"
    case png = "image/png"
    case zip = "application/zip"
    case pdf = "application/pdf"
    case doc = "application/msword"
    case unknown
    
    public init(contentType: Any?) {
        guard let contentType: String = contentType as? String else {
            self = .unknown
            return
        }
        self = ContentType(rawValue: contentType) ?? .unknown
    }
    
    public init(extension: String?) {
        switch `extension` {
        case "jpeg": self = .jpeg
        case "jpg": self = .jpg
        case "png": self = .png
        case "zip": self = .zip
        case "pdf": self = .pdf
        case "doc": self = .doc
        default: self = .unknown
        }
    }
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
                              _ cache: NetworkCacheProtocol?,
                              completion: @escaping (Result<Data>) -> Void) -> URLSessionDataTask? {
        let hash: Any = request.hashValue
        log(request, logger)
        if let cache: NetworkCacheProtocol = cache,
            let data: Data = try? cache.read(hash: hash, logger: logger) {
            let result: Result<Data> = Result.success(data)
            log(request, data, logger)
            completion(result)
            return nil
        }
        
        guard Reachability.isConnected else {
            let networkError: NetworkError = .connectionFailure
            let result: Result<Data> = Result.failure(networkError)
            log(request, networkError, logger)
            completion(result)
            return nil
        }
        
        let sessionDelegate = SessionDelegate(hash, logger, cache, completion)
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
    private let cache: NetworkCacheProtocol?
    private var data: Data
    private let successStatusCode: Range<Int>
    private let completion: (Result<Data>) -> Void
    
    init(_ requestHash: Any,
         _ logger: LoggerProtocol?,
         _ cache: NetworkCacheProtocol?,
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
                let networkError: NetworkError = .init(error)
                let result: Result<Data> = Result.failure(networkError)
                log(task, networkError, error, self.logger)
                self.completion(result)
                return
        }
        
        guard self.successStatusCode ~= response.statusCode else {
            let networkError: NetworkError = .errorStatusCode(response.statusCode)
            let result: Result<Data> = Result.failure(networkError)
            log(response, networkError, self.logger)
            self.completion(result)
            return
        }
        
        log(response, self.data, self.logger)
        try? self.cache?.write(hash: self.requestHash, data: self.data, logger: self.logger)
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

private func log(_ request: URLRequest,
                 _ logger: LoggerProtocol?) {
    guard let logger: LoggerProtocol = logger else { return }
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
        string += "" + dataToString(body).replacingOccurrences(of: "\n", with: "\n\t")
    }
    logger.log(.info, string)
}

private func log(_ response: HTTPURLResponse,
                 _ body: Data,
                 _ logger: LoggerProtocol?) {
    guard let logger: LoggerProtocol = logger else { return }
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
        string += "\n\t" + dataToString(body).replacingOccurrences(of: "\n", with: "\n\t")
    }
    logger.log(.info, string)
}

private func log(_ request: URLRequest,
                 _ body: Data,
                 _ logger: LoggerProtocol?) {
    guard let logger: LoggerProtocol = logger else { return }
    var string: String = ""
    string += "\nCACHE"
    string += "\n" + (request.url?.absoluteString ?? "")
    if let headers = request.allHTTPHeaderFields,
        !headers.isEmpty {
        string += "\n\t" + "HEADERS:"
        for header in headers {
            string += "\n\t\t" + header.key + ": " + header.value
        }
    }
    if !body.isEmpty {
        string += "\n\t" + "BODY:"
        string += "\n\t" + dataToString(body).replacingOccurrences(of: "\n", with: "\n\t")
    }
    logger.log(.info, string)
}

private func log(_ request: URLRequest,
                 _ networkError: NetworkError,
                 _ logger: LoggerProtocol?) {
    guard let logger: LoggerProtocol = logger else { return }
    var string: String = ""
    string += "\nERROR: \(networkError.debugDescription)"
    string += "\n" + (request.url?.absoluteString ?? "")
    logger.log(.warning, string)
}

private func log(_ task: URLSessionTask,
                 _ networkError: NetworkError,
                 _ error: Error?,
                 _ logger: LoggerProtocol?) {
    guard let logger: LoggerProtocol = logger else { return }
    var string: String = ""
    if networkError.isCancelled {
        string += "\nCANCELLED"
        string += "\n" + (task.originalRequest?.url?.absoluteString ?? "")
        logger.log(.info, string)
    } else {
        string += "\nERROR: \(networkError.debugDescription)"
        string += "\n" + (task.originalRequest?.url?.absoluteString ?? "")
        if let error = error {
            string += "\n\(error.localizedDescription)"
        }
        logger.log(.warning, string)
    }
}

private func log(_ response: HTTPURLResponse,
                 _ networkError: NetworkError,
                 _ logger: LoggerProtocol?) {
    guard let logger: LoggerProtocol = logger else { return }
    var string: String = ""
    string += "\nERROR: \(networkError.debugDescription)"
    string += "\n" + (response.url?.absoluteString ?? "")
    logger.log(.warning, string)
}

private func dataToString(_ data: Data) -> String {
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
        return String(data: prettyData, encoding: .utf8) ?? ""
    } catch let error {
        let size: Int = data.count
        switch size {
        case ..<(1_024):
            return String(format: "Size: %lldB", size)
        case 1_024..<(1_024 << 10):
            return String(format: "Size: %3.2fkB", Double(size) / Double(1_024))
        case 1_024..<(1_024 << 20):
            return String(format: "Size: %3.2fMB", Double(size) / Double(1_024 << 10))
        default:
            return error.localizedDescription
        }
    }
}
