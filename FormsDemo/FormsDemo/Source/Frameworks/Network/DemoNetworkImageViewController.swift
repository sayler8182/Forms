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
import FormsUtils
import UIKit

// MARK: DemoNetworkImageViewController
class DemoNetworkImageViewController: FormsTableViewController {
    private let progressBar = Components.progress.progressBar()
    private let imageView = Components.image.default()
        .with(contentMode: .scaleAspectFit)
        .with(height: 400.0)
    private let reloadButton = Components.button.default()
        .with(title: "Reload")
    private let reloadAndCancelButton = Components.button.default()
        .with(title: "Reload and Cancel")
    private let networkImagesButton = Components.button.default()
        .with(title: "Load from NetworkImages")
    private let imageViewButton = Components.button.default()
        .with(title: "Load from UIImageView")
    
    private lazy var provider = DemoProvider(delegate: self)
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupView() {
        super.setupView()
        self.getContent()
    }
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.progressBar,
            self.imageView,
            self.reloadButton,
            self.reloadAndCancelButton,
            self.networkImagesButton,
            self.imageViewButton
        ], divider: self.divider)
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
        self.networkImagesButton.onClick = Unowned(self) { (_self) in
            _self.reloadButton.startLoading()
            _self.getContentFromNetworkImages()
        }
        self.imageViewButton.onClick = Unowned(self) { (_self) in
            _self.startShimmering()
            let request = NetworkImageRequest(
                url: Mock().imageUrl([.quality(.high)]))
            _self.imageView.setImage(request: request) { [weak _self] (_, _) in
                guard let _self = _self else { return }
                _self.stopShimmering()
            }
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
    
    func getContentFromNetworkImages() {
        self.progressBar.progress = 0.0
        self.startShimmering()
        self.provider.getContentFromNetworkImages()
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
    
    private let networkImages = NetworkImages()
    
    private var networkImageRequest: NetworkImageRequest? = nil
    private var contentTask: NetworkTask? = nil
    
    init(delegate: DemoDisplayLogic) {
        self.delegate = delegate
    }
    
    func getContent() {
        self.contentTask = DemoNetworkMethods.images.get(
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
            },
            onError: { [weak self] (error: NetworkError) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.displayContentError(error.debugDescription, error.isCancelled)
                }
        })
    }
    
    func getContentFromNetworkImages() {
        let request = NetworkImageRequest(
            url: Mock().imageUrl([.quality(.high)]))
        self.networkImages.image(
            request: request,
            onProgress: { [weak self] (_, _, progress: Double) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.displayContentProgress(progress)
                }
            },
            onSuccess: { [weak self] (image: UIImage) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.displayContent(image)
                }
            },
            onError: { [weak self] (error: NetworkError) in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.displayContentError(error.debugDescription, error.isCancelled)
                }
        })
        self.networkImageRequest = request
    }
    
    func getContentCancel() {
        self.contentTask?.cancel()
        self.networkImageRequest?.cancel()
    }
}

// MARK: DemoNetworkMethods
private enum DemoNetworkMethods {
    static var images: NetworkMethodsImages {
        NetworkMethodsImages()
            .with(logger: ConsoleLogger())
            .with(cache: NetworkTmpCache(ttl: 60 * 60))
    }
}

// MARK: NetworkMethodsImages
private class NetworkMethodsImages: NetworkMethod {
    @discardableResult
    func get(onProgress: @escaping NetworkOnProgress,
             onSuccess: @escaping NetworkOnSuccess,
             onError: @escaping NetworkOnError,
             onCompletion: NetworkOnCompletion? = nil) -> NetworkTask {
        let request = NetworkRequest(
            url: Mock().imageUrl([.quality(.high)]))
        return self.provider.call(
            request: request,
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
}
