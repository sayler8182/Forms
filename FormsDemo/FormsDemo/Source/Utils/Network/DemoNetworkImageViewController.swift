//
//  DemoNetworkImageViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import UIKit

// MARK: DemoNetworkImageViewController
class DemoNetworkImageViewController: ViewController {
    private let imageView = UIImageView()
        .with(contentMode: .scaleAspectFit)
    
    private lazy var provider = DemoProvider(delegate: self)
    
    override func setupView() {
        super.setupView()
        self.startShimmering()
        self.provider.getContent()
    }
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.imageView, with: [
            Anchor.to(self.view).vertical.safeArea.offset(16),
            Anchor.to(self.view).horizontal.offset(16)
        ])
    }
}

// MARK: DemoProviderDelegate
extension DemoNetworkImageViewController: DemoProviderDelegate {
    func displayContent(_ image: UIImage?) {
        self.stopShimmering()
        self.imageView.image = image
    }
    
    func displayContentError() {
        self.stopShimmering()
        Toast.error()
            .with(title: "Unexpected error")
            .show(in: self.navigationController)
    }
}

// MARK: DemoProviderDelegate
private protocol DemoProviderDelegate: class {
    func displayContent(_ image: UIImage?)
    func displayContentError()
}

// MARK: DemoProvider
private class DemoProvider {
     private weak var delegate: DemoProviderDelegate?
     
     init(delegate: DemoProviderDelegate) {
         self.delegate = delegate
     }
    
    func getContent() {
        NetworkMethods.images.get(
            onSuccess: { [weak self] (data: Data) in
                guard let `self` = self else { return }
                let image: UIImage? = UIImage(data: data)
                DispatchQueue.main.async {
                    self.delegate?.displayContent(image)
                }
        }, onError: { [weak self] (_) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.delegate?.displayContentError()
            }
        })
    }
}

// MARK: NetworkMethods
private struct NetworkMethods {
    private init() { }
    
    static var images: NetworkMethodsImages { NetworkMethodsImages() }
}

private class NetworkMethodsImages: Requestable {
    func get(onSuccess: @escaping (Data) -> Void,
             onError: @escaping (ApiError) -> Void,
             onCompletion: ((Data?, ApiError?) -> Void)? = nil) {
        let request = Request(
            url: "https://upload.wikimedia.org/wikipedia/commons/0/0f/Welsh_Corgi_Pembroke_WPR_Kamien_07_10_07.jpg".url,
            method: .GET)
        self.call(
            request,
            cache: NetworkCache(ttl: 60 * 60),
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
}
