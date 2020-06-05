//
//  DemoNetworkImageViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/14/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsAnchor
import FormsInjector
import FormsLogger
import FormsMock
import FormsNetworking
import FormsToastKit
import UIKit

// MARK: DemoNetworkImageViewController
class DemoNetworkImageViewController: FormsViewController {
    private let progressBar = Components.progress.progressBar()
    private let imageView = Components.image.default()
        .with(contentMode: .scaleAspectFit)
    private let reloadButton = Components.button.default()
        .with(title: "Reload")
    private let reloadAndCancelButton = Components.button.default()
        .with(title: "Reload and Cancel")
    
    private lazy var provider = DemoProvider(delegate: self)
    
    override func setupView() {
        super.setupView()
        self.getContent()
    }
    
    override func setupContent() {
        super.setupContent()
        self.view.addSubview(self.progressBar, with: [
            Anchor.to(self.view).top.safeArea.offset(16),
            Anchor.to(self.view).horizontal.offset(16)
        ])
        self.view.addSubview(self.imageView, with: [
            Anchor.to(self.progressBar).topToBottom,
            Anchor.to(self.view).horizontal.offset(16)
        ])
        self.view.addSubview(self.reloadButton, with: [
            Anchor.to(self.imageView).topToBottom.offset(8),
            Anchor.to(self.view).horizontal.offset(16)
        ])
        self.view.addSubview(self.reloadAndCancelButton, with: [
            Anchor.to(self.reloadButton).topToBottom.offset(8),
            Anchor.to(self.view).horizontal.offset(16),
            Anchor.to(self.view).bottom.safeArea
        ])
    }
    
    override func setupActions() {
        super.setupActions()
        self.reloadButton.onClick = Unowned(self) { (_self) in
            _self.reloadButton.startLoading()
            _self.getContent()
        }
        self.reloadAndCancelButton.onClick = Unowned(self) { (_self) in
            _self.getContent()
            _self.getContentCancel()
        }
    }
}

// MARK: DemoProviderDelegate
extension DemoNetworkImageViewController: DemoDisplayLogic {
    func getContent() {
        self.progressBar.progress = 0.0
        self.startShimmering()
        self.provider.getContent()
    }
    
    func getContentCancel() {
        self.provider.getContentCancel()
    }
    
    func displayContent(_ image: UIImage?) {
        self.reloadButton.stopLoading()
        self.stopShimmering()
        self.imageView.image = image
    }
    
    func displayContentProgress(_ progress: Double) {
        self.progressBar.progress = progress.asCGFloat
    }
    
    func displayContentError(_ error: String,
                             _ isCancelled: Bool) {
        self.reloadButton.stopLoading()
        self.stopShimmering()
        guard !isCancelled else { return }
        Toast.error()
            .with(title: error)
            .show(in: self.navigationController)
    }
}

// MARK: DemoDisplayLogic
private protocol DemoDisplayLogic: class {
    func displayContent(_ image: UIImage?)
    func displayContentProgress(_ progress: Double)
    func displayContentError(_ error: String,
                             _ isCancelled: Bool)
}

// MARK: DemoProvider
private class DemoProvider {
     private weak var delegate: DemoDisplayLogic?
     
    private var contentTask: NetworkTask? = nil
    
     init(delegate: DemoDisplayLogic) {
         self.delegate = delegate
     }
    
    func getContent() {
        self.contentTask = NetworkMethods.images.get(
            onProgress: { [weak self] (_, _, progress: Double) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.displayContentProgress(progress)
                }
            },
            onSuccess: { [weak self] (data: Data) in
                guard let `self` = self else { return }
                let image: UIImage? = UIImage(data: data)
                DispatchQueue.main.async {
                    self.delegate?.displayContent(image)
                }
        }, onError: { [weak self] (error) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.delegate?.displayContentError(error.debugDescription, error.isCancelled)
            }
        })
    }
    
    func getContentCancel() {
        self.contentTask?.cancel()
    }
}

// MARK: NetworkMethods
private struct NetworkMethods {
    private init() { }
    
    static var images: NetworkMethodsImages { NetworkMethodsImages() }
}

// MARK: NetworkMethodsImages
private struct NetworkMethodsImages: Requestable {
    @discardableResult
    func get(onProgress: @escaping (Int64, Int64, Double) -> Void,
             onSuccess: @escaping (Data) -> Void,
             onError: @escaping (NetworkError) -> Void,
             onCompletion: ((Data?, NetworkError?) -> Void)? = nil) -> NetworkTask {
        let request = Request(
            url: Mock().imageUrl([.quality(.high)]))
        return self.call(
            request,
            logger: ConsoleLogger(),
            cache: NetworkTmpCache(ttl: 60 * 60),
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
}
