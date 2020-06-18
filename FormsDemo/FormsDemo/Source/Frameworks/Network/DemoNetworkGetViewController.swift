//
//  DemoNetworkGetViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsInjector
import FormsLogger
import FormsNetworking
import UIKit

// MARK: DemoNetworkGetViewController
class DemoNetworkGetViewController: FormsViewController {
    private let statusLabel = Components.label.default()
        .with(text: " ")
    
    private lazy var provider = DemoProvider(delegate: self)
    
    override func setupView() {
        super.setupView()
        self.startShimmering()
        self.provider.getContent()
    }
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.statusLabel, with: [
            Anchor.to(self.view).top.safeArea.offset(16),
            Anchor.to(self.view).horizontal.offset(16)
        ])
    }
}

// MARK: DemoProviderDelegate
extension DemoNetworkGetViewController: DemoProviderDelegate {
    func displayContent(_ data: DemoNetworkGetOutput) {
        self.stopShimmering()
        self.statusLabel.text = data.url
    }
    
    func displayContentError(_ error: String) {
        self.stopShimmering()
        self.statusLabel.text = error
    }
}

// MARK: DemoProviderDelegate
private protocol DemoProviderDelegate: class {
    func displayContent(_ data: DemoNetworkGetOutput)
    func displayContentError(_ error: String)
}

// MARK: DemoProvider
private class DemoProvider {
     private weak var delegate: DemoProviderDelegate?
     
     init(delegate: DemoProviderDelegate) {
         self.delegate = delegate
     }
    
    func getContent() {
        DemoNetworkMethods.demo.get(
            onSuccess: { [weak self] (data: DemoNetworkGetOutput) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.displayContent(data)
                }
            },
            onError: { [weak self] _ in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.displayContentError("Some error")
                }
        })
    }
}

// MARK: NetworkMethods
private enum DemoNetworkMethods {
    static var demo: NetworkMethodsDemo {
        NetworkMethodsDemo()
            .with(cache: NetworkTmpCache(ttl: 60 * 60))
    }
}

// MARK: NetworkMethodsTest
private class NetworkMethodsDemo: NetworkMethod {
    @discardableResult
    func get<T: Parseable>(onSuccess: @escaping NetworkOnGenericSuccess<T>,
                           onError: @escaping NetworkOnError,
                           onCompletion: NetworkOnGenericCompletion<T>? = nil) -> NetworkTask {
        let request = NetworkRequest(url: "https://postman-echo.com/get?foo1=bar1&foo2=bar2".url)
            .with(method: .GET)
            .with(interceptor: DemoNetworkRequestInterceptor())
        return self.provider.call(
            request: request,
            parser: NetworkResponseParser(),
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
}

// MARK: DemoNetworkRequestInterceptor
private class DemoNetworkRequestInterceptor: NetworkRequestInterceptor {
    override func setHeaders(_ request: NetworkRequest) {
        let headers = request.headers
        request.request?.allHTTPHeaderFields = headers
    }
}

// MARK: DemoNetworkGetOutput
struct DemoNetworkGetOutput: Codable, Parseable {
    let url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
