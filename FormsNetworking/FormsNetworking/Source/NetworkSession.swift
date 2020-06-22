//
//  NetworkSession.swift
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

// MARK: HTTPMethod
public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

// MARK: NetworkSessionProtocol
public protocol NetworkSessionProtocol {
    func call(request: URLRequest,
              logger: Logger?,
              cache: NetworkCache?,
              onProgress: NetworkOnProgress?,
              onCompletion: @escaping NetworkOnGenericCompletion<Data>) -> URLSessionDataTask?
}

public extension NetworkSessionProtocol {
    func call(request: URLRequest,
              onProgress: NetworkOnProgress?,
              onCompletion: @escaping NetworkOnGenericCompletion<Data>) -> URLSessionDataTask? {
        self.call(
            request: request,
            logger: nil,
            cache: nil,
            onProgress: onProgress,
            onCompletion: onCompletion)
    }
}

// MARK: FileNetworkSession
public class FileNetworkSession: NetworkSessionProtocol {
    private let filename: String?
    private let delay: Double
    
    public init(filename: String? = nil,
                delay: Double = 0.5) {
        self.filename = filename
        self.delay = delay
    }
    
    public func call(request: URLRequest,
                     logger: Logger?,
                     cache: NetworkCache?,
                     onProgress: NetworkOnProgress?,
                     onCompletion: @escaping NetworkOnGenericCompletion<Data>) -> URLSessionDataTask? {
        log(request, logger)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + self.delay) {
            let _filename: String? = self.filename ?? request.url?.lastPathComponent
            guard let filename: String = _filename,
                let url: URL = Bundle.main.url(forResource: filename, withExtension: "json"),
                let data: Data = try? Data(contentsOf: url) else {
                    let networkError: NetworkError = .connectionFailure
                    log(request, networkError, logger)
                    onCompletion(nil, networkError)
                    return
            }
            log(request, data, logger)
            onCompletion(data, nil)
        }
        return nil
    }
}

// MARK: NetworkSession
public class NetworkSession: NetworkSessionProtocol {
    private var logger: Logger?
    private var cache: NetworkCache?
    
    public init(logger: Logger? = nil,
                cache: NetworkCache? = nil) {
        self.logger = logger
        self.cache = cache
    }
    
    public func call(request: URLRequest,
                     logger: Logger?,
                     cache: NetworkCache?,
                     onProgress: NetworkOnProgress?,
                     onCompletion: @escaping NetworkOnGenericCompletion<Data>) -> URLSessionDataTask? {
        let logger: Logger? = logger ?? self.logger
        let cache: NetworkCache? = cache ?? self.cache
        let hash: Any = request.hashValue
        log(request, logger)
        if let cache: NetworkCache = cache,
            let data: Data = try? cache.read(hash: hash, logger: logger) {
            log(request, data, logger)
            onCompletion(data, nil)
            return nil
        }
        
        guard NetworkReachability.isConnected else {
            let networkError: NetworkError = .connectionFailure
            log(request, networkError, logger)
            onCompletion(nil, networkError)
            return nil
        }
        
        let sessionDelegate = SessionDelegate(hash, logger, cache, onProgress, onCompletion)
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.httpShouldSetCookies = true
        configuration.timeoutIntervalForRequest = 30
        let session = URLSession(
            configuration: configuration,
            delegate: sessionDelegate,
            delegateQueue: nil)
        let task: URLSessionDataTask = session.dataTask(with: request)
        task.resume()
        session.finishTasksAndInvalidate()
        return task
    }
}

// MARK: SessionDelegate
internal class SessionDelegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    private let requestHash: Any
    private let logger: Logger?
    private let cache: NetworkCache?
    private var data: Data
    private let successStatusCode: Range<Int>
    private let onProgress: NetworkOnProgress?
    private let onCompletion: NetworkOnGenericCompletion<Data>
    
    private var totalSize: Int64 = 0
    private var size: Int64 {
        let count: Int = self.data.count
        return Int64(count)
    }
    private var progress: Double {
        guard self.totalSize != 0 else { return 0.0 }
        return Double(self.size) / Double(self.totalSize)
    }
    
    init(_ requestHash: Any,
         _ logger: Logger?,
         _ cache: NetworkCache?,
         _ onProgress: NetworkOnProgress?,
         _ onCompletion: @escaping NetworkOnGenericCompletion<Data>) {
        self.requestHash = requestHash
        self.logger = logger
        self.cache = cache
        self.data = Data()
        self.successStatusCode = 200..<300
        self.onProgress = onProgress
        self.onCompletion = onCompletion
        super.init()
    }
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        self.onProgress?(self.size, self.totalSize, 1.0)
        guard error == nil,
            let response = task.response as? HTTPURLResponse else {
                let networkError: NetworkError = .init(error)
                log(task, networkError, error, self.logger)
                self.onCompletion(nil, networkError)
                return
        }
        
        guard self.successStatusCode ~= response.statusCode else {
            let networkError: NetworkError = .errorStatusCode(response.statusCode)
            log(response, networkError, self.logger)
            self.onCompletion(nil, networkError)
            return
        }
        
        log(response, self.data, self.logger)
        try? self.cache?.write(hash: self.requestHash, data: self.data, logger: self.logger)
        self.onCompletion(self.data, nil)
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.totalSize = response.expectedContentLength
        log(self.size, self.totalSize, self.progress, self.logger)
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        self.data.append(data)
        log(self.size, self.totalSize, self.progress, self.logger)
        self.onProgress?(self.size, self.totalSize, self.progress)
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        NetworkPinning.validate(
            session,
            didReceive: challenge,
            completionHandler: completionHandler)
    }
}

private func log(_ request: URLRequest,
                 _ logger: Logger?) {
    guard let logger: Logger = logger else { return }
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
    logger.log(LogType.info, string)
}

private func log(_ response: HTTPURLResponse,
                 _ body: Data,
                 _ logger: Logger?) {
    guard let logger: Logger = logger else { return }
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
    logger.log(LogType.info, string)
}

private func log(_ request: URLRequest,
                 _ body: Data,
                 _ logger: Logger?) {
    guard let logger: Logger = logger else { return }
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
    logger.log(LogType.info, string)
}

private func log(_ request: URLRequest,
                 _ networkError: NetworkError,
                 _ logger: Logger?) {
    guard let logger: Logger = logger else { return }
    var string: String = ""
    string += "\nERROR: \(networkError.debugDescription)"
    string += "\n" + (request.url?.absoluteString ?? "")
    logger.log(LogType.warning, string)
}

private func log(_ task: URLSessionTask,
                 _ networkError: NetworkError,
                 _ error: Error?,
                 _ logger: Logger?) {
    guard let logger: Logger = logger else { return }
    var string: String = ""
    if networkError.isCancelled {
        string += "\nCANCELLED"
        string += "\n" + (task.originalRequest?.url?.absoluteString ?? "")
        logger.log(LogType.info, string)
    } else {
        string += "\nERROR: \(networkError.debugDescription)"
        string += "\n" + (task.originalRequest?.url?.absoluteString ?? "")
        if let error = error {
            string += "\n\(error.localizedDescription)"
        }
        logger.log(LogType.warning, string)
    }
}

private func log(_ response: HTTPURLResponse,
                 _ networkError: NetworkError,
                 _ logger: Logger?) {
    guard let logger: Logger = logger else { return }
    var string: String = ""
    string += "\nERROR: \(networkError.debugDescription)"
    string += "\n" + (response.url?.absoluteString ?? "")
    logger.log(LogType.warning, string)
}

private func log(_ size: Int64,
                 _ totalSize: Int64,
                 _ progress: Double,
                 _ logger: Logger?) {
    guard let logger: Logger = logger else { return }
    var string: String = ""
    string += size == 0 ? "\n" : ""
    string += "PROGRESS: \(size) / \(totalSize) - \(Int(progress * 100))%"
    logger.log(LogType.info, string)
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
