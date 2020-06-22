//
//  DemoNetworkUploadViewController.swift
//  FormsDemo
//
//  Created by Konrad on 6/8/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsInjector
import FormsLogger
import FormsNetworking
import UIKit

// MARK: DemoNetworkUploadViewController
class DemoNetworkUploadViewController: FormsViewController {
    private let statusLabel = Components.label.default()
        .with(text: "Uploaded")
    
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
extension DemoNetworkUploadViewController: DemoProviderDelegate {
    func displayContent(_ data: DemoNetworkUploadOutput) {
        self.stopShimmering()
    }
    
    func displayContentError(_ error: String) {
        self.stopShimmering()
        self.statusLabel.text = error
    }
}

// MARK: DemoProviderDelegate
private protocol DemoProviderDelegate: class {
    func displayContent(_ data: DemoNetworkUploadOutput)
    func displayContentError(_ error: String)
}

// MARK: DemoProvider
private class DemoProvider {
     private weak var delegate: DemoProviderDelegate?
     
     init(delegate: DemoProviderDelegate) {
         self.delegate = delegate
     }
    
    func getContent() {
        let content = DemoNetworkMethodsDemo.Content(
            name: "ImageName",
            image: UIImage(color: Theme.Colors.red))
        DemoNetworkMethods.demo(content).call(
            onSuccess: { [weak self] (data: DemoNetworkUploadOutput) in
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
    typealias demo = DemoNetworkMethodsDemo
}

// MARK: DemoNetworkMethodsDemo
private class DemoNetworkMethodsDemo: NetworkMethod {
    struct Content: NetworkMethodContent {
        let name: String
        let image: Data
        
        var body: Data? {
            return self.multiparts.multipartDescription
        }
        var parameters: [String: Any]? {
            return nil
        }
        var multiparts: [MultipartItem] {
            return [
                MultipartItem(
                    name: "name",
                    value: self.name),
                MultipartItem(
                    name: self.name,
                    filename: "filename.jpg",
                    type: .jpeg,
                    body: self.image)
            ]
        }
        
        init(name: String,
             image: UIImage?) {
            self.name = name
            self.image = image?.jpegData(compressionQuality: 0.95) ?? Data()
        }
    }
    
    var content: NetworkMethodContent
    var method: HTTPMethod = .POST
    var url: URL! = "https://httpbin.org/post".url
    
    init(_ content: Content) {
        self.content = content
    } 
}

// MARK: DemoNetworkUploadOutput
struct DemoNetworkUploadOutput: Codable, Parseable {
    let args: [String: String]
    let data: String
    let files: [String: String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.args = try container.decode([String: String].self, forKey: .args)
        self.data = try container.decode(String.self, forKey: .data)
        self.files = try container.decode([String: String].self, forKey: .files)
    }
    
    enum CodingKeys: String, CodingKey {
        case args
        case data
        case files
    }
}
