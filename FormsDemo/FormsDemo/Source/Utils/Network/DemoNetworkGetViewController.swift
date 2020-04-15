//
//  DemoNetworkGetViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: DemoNetworkGetViewController
class DemoNetworkGetViewController: ViewController {
    private let statusLabel = Components.label.label()
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
    func displayContent(_ data: DemoNetworData) {
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
    func displayContent(_ data: DemoNetworData)
    func displayContentError(_ error: String)
}

// MARK: DemoProvider
private class DemoProvider {
     private weak var delegate: DemoProviderDelegate?
     
     init(delegate: DemoProviderDelegate) {
         self.delegate = delegate
     }
    
    func getContent() {
        NetworkMethods.demo.get(
            onSuccess: { [weak self] (data: DemoNetworData) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.displayContent(data)
                }
        }, onError: { [weak self] (_) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.delegate?.displayContentError("Some error")
            }
        })
    }
}

// MARK: NetworkMethods
private struct NetworkMethods {
    private init() { }
    
    static var demo: NetworkMethodsTest { NetworkMethodsTest() }
}

private class NetworkMethodsTest: Requestable {
    @Injected
    private var logger: LoggerProtocol // swiftlint:disable:this let_var_whitespace
    private var parser = AppResponseParser()
    
    func get<T: Parseable>(onSuccess: @escaping (T) -> Void,
                           onError: @escaping (ApiError) -> Void,
                           onCompletion: ((T?, ApiError?) -> Void)? = nil) {
        let request = Request(
            url: "https://postman-echo.com/get?foo1=bar1&foo2=bar2".url,
            method: .GET,
            headers: [:],
            body: nil,
            provider: AppRequestProvider())
        self.call(
            request,
            logger: self.logger,
            parser: self.parser,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
}

private class AppRequestProvider: RequestProvider {
    override func setHeaders(_ request: inout Request) {
        let headers = request.headers
        request.request.allHTTPHeaderFields = headers
    }
}

private class AppResponseParser: ResponseParser { }

struct DemoNetworData: Codable, Parseable {
    let url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
