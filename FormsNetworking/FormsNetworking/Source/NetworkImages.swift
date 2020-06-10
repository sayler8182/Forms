//
//  NetworkImages.swift
//  FormsNetworking
//
//  Created by Konrad on 6/9/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsLogger
import UIKit

public typealias NetworkImagesOnProgress = (_ size: Int64, _ totalSize: Int64, _ progress: Double) -> Void
public typealias NetworkImagesOnSuccess = (_ image: UIImage) -> Void
public typealias NetworkImagesOnError = (_ error: NetworkError) -> Void
public typealias NetworkImagesOnCompletion = (_ image: UIImage?, _ error: NetworkError?) -> Void

// MARK: NetworkImageRequest
public class NetworkImageRequest: ExpressibleByStringLiteral {
    public let url: URL?
    
    public var cache: UIImage?
    public var dispatchQueue: DispatchQueue
    public var dispatchProgressQueue: DispatchQueue
    public var placeholder: UIImage?
    public var scale: CGFloat
    
    public var cornerRadius: CGFloat?
    public var filter: String?
    public var filterParameters: [String: Any]?
    public var isRounded: Bool?
    public var scaleToFit: CGSize?
    public var scaleToFill: CGSize?
    
    fileprivate var task: NetworkTask?
    
    public required convenience init(stringLiteral value: StringLiteralType) {
        self.init(url: URL(string: value))
    }
    
    public init(url: URL?) {
        self.url = url
        self.dispatchQueue = DispatchQueue.main
        self.dispatchProgressQueue = DispatchQueue.main
        self.scale = UIScreen.main.scale
    }
    
    public func cancel() {
        self.task?.cancel()
    }
}
public extension NetworkImageRequest {
    func with(cache: UIImage?) -> Self {
        self.cache = cache
        return self
    }
    func with(cornerRadius: CGFloat?) -> Self {
        self.cornerRadius = cornerRadius
        return self
    }
    func with(dispatchQueue: DispatchQueue) -> Self {
        self.dispatchQueue = dispatchQueue
        return self
    }
    func with(dispatchProgressQueue: DispatchQueue) -> Self {
        self.dispatchProgressQueue = dispatchProgressQueue
        return self
    }
    func with(filter: String?) -> Self {
        self.filter = filter
        return self
    }
    func with(filterParameters: [String: Any]?) -> Self {
        self.filterParameters = filterParameters
        return self
    }
    func with(isRounded: Bool?) -> Self {
        self.isRounded = isRounded
        return self
    }
    func with(placeholder: UIImage?) -> Self {
        self.placeholder = placeholder
        return self
    }
    func with(scale: CGFloat) -> Self {
        self.scale = scale
        return self
    }
    func with(scaleToFit: CGSize?) -> Self {
        self.scaleToFit = scaleToFit
        return self
    }
    func with(scaleToFill: CGSize?) -> Self {
        self.scaleToFill = scaleToFill
        return self
    }
}

// MARK: NetworkImagesProtocol
public protocol NetworkImagesProtocol {
    func image(request: NetworkImageRequest,
               onProgress: NetworkImagesOnProgress?,
               onSuccess: NetworkImagesOnSuccess?,
               onError: NetworkImagesOnError?,
               onCompletion: NetworkImagesOnCompletion?)
}
extension NetworkImagesProtocol {
    func image(request: NetworkImageRequest,
               onProgress: NetworkImagesOnProgress?,
               onSuccess: NetworkImagesOnSuccess?,
               onError: NetworkImagesOnError?) {
        self.image(
            request: request,
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: nil)
    }
    func image(request: NetworkImageRequest,
               onProgress: NetworkImagesOnProgress?,
               onCompletion: NetworkImagesOnCompletion?) {
        self.image(
            request: request,
            onProgress: onProgress,
            onSuccess: nil,
            onError: nil,
            onCompletion: onCompletion)
    }
}

// MARK: Images
public class NetworkImages: NetworkImagesProtocol {
    private let logger: Logger?
    private let cache: NetworkCache?
    
    private let queue = DispatchQueue.global(qos: .background)
    
    public init(logger: Logger? = nil,
                cache: NetworkCache? = nil) {
        self.logger = logger
        self.cache = cache
    }
    
    public func image(request: NetworkImageRequest,
                      onProgress: NetworkImagesOnProgress? = nil,
                      onSuccess: NetworkImagesOnSuccess? = nil,
                      onError: NetworkImagesOnError? = nil,
                      onCompletion: NetworkImagesOnCompletion? = nil) {
        self.queue.async {
            self.fetchImage(
                request: request,
                onProgress: onProgress,
                onSuccess: onSuccess,
                onError: onError,
                onCompletion: onCompletion)
        }
    }
}

// MARK: NetworkImages
extension NetworkImages {
    private func fetchImage(request: NetworkImageRequest,
                            onProgress: NetworkImagesOnProgress?,
                            onSuccess: NetworkImagesOnSuccess?,
                            onError: NetworkImagesOnError?,
                            onCompletion: NetworkImagesOnCompletion?) {
        if let image: UIImage = request.cache {
            request.dispatchQueue.async {
                onSuccess?(image)
                onCompletion?(image, nil)
            }
        } else if let url: URL = request.url {
            let task: NetworkTask = self.fetchImage(
                url: url,
                request: request,
                onProgress: onProgress,
                onSuccess: onSuccess,
                onError: onError,
                onCompletion: onCompletion)
            request.task = task
        } else if let image: UIImage = request.placeholder {
            request.dispatchQueue.async {
                onSuccess?(image)
                onCompletion?(image, nil)
            }
        } else {
            request.dispatchQueue.async {
                onError?(.emptyResponse)
                onCompletion?(nil, .emptyResponse)
            }
        }
    }
    
    private func fetchImage(url: URL,
                            request: NetworkImageRequest,
                            onProgress: NetworkImagesOnProgress?,
                            onSuccess: NetworkImagesOnSuccess?,
                            onError: NetworkImagesOnError?,
                            onCompletion: NetworkImagesOnCompletion?) -> NetworkTask {
        let method = NetworkImagesMethod()
            .with(logger: self.logger)
            .with(cache: self.cache)
        return method.fetch(
            url: url,
            onProgress: { (size: Int64, totalSize: Int64, progress: Double) in
                guard let onProgress = onProgress else { return }
                request.dispatchProgressQueue.async {
                    onProgress(size, totalSize, progress)
                }
        }, onSuccess: { (data: Data) in
            if let image: UIImage = UIImage(data: data, scale: request.scale) {
                if let onSuccess = onSuccess {
                    request.dispatchProgressQueue.async {
                        onSuccess(image)
                    }
                }
            } else if let onError = onError {
                request.dispatchProgressQueue.async {
                    onError(.incorrectResponseFormat)
                }
            }
        }, onError: { (error: NetworkError) in
            guard let onError = onError else { return }
            request.dispatchProgressQueue.async {
                onError(error)
            }
        }, onCompletion: { (data: Data?, error: NetworkError?) in
            guard let onCompletion = onCompletion else { return }
            if let data: Data = data {
                if let image: UIImage = UIImage(data: data, scale: request.scale) {
                    request.dispatchProgressQueue.async {
                        onCompletion(image, nil)
                    }
                } else {
                    onCompletion(nil, .incorrectResponseFormat)
                }
            } else {
                request.dispatchProgressQueue.async {
                    onCompletion(nil, error)
                }
            }
        })
    }
}

// MARK: NetworkImagesMethod
private class NetworkImagesMethod: NetworkMethod {
    func fetch(url: URL,
               onProgress: @escaping NetworkOnProgress,
               onSuccess: @escaping NetworkOnGenericSuccess<Data>,
               onError: @escaping NetworkOnError,
               onCompletion: @escaping NetworkOnGenericCompletion<Data>) -> NetworkTask {
        let request = NetworkRequest(
            url: url)
        return self.provider.call(
            request: request,
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
}

// MARK: UIImage - Transform
extension UIImage {
    private func transform(_ request: NetworkImageRequest) -> UIImage {
        var image: UIImage = self
        image = self.transformScale(request)
        image = self.transformRadius(request)
        image = self.transformFilter(request)
        return image
    }
    
    private func transformScale(_ request: NetworkImageRequest) -> UIImage {
        if let scale: CGSize = request.scaleToFit {
            return self.scaled(toFit: scale)
        } else if let scale: CGSize = request.scaleToFill {
            return self.scaled(toFill: scale)
        } else {
            return self
        }
    }
    
    private func transformRadius(_ request: NetworkImageRequest) -> UIImage {
        if let isRounded: Bool = request.isRounded,
            isRounded == true {
            return self.circled()
        } else if let radius: CGFloat = request.cornerRadius {
            return self.rounded(radius: radius)
        } else {
            return self
        }
    }
    
    private func transformFilter( _ request: NetworkImageRequest) -> UIImage {
        if let name: String = request.filter {
            let parameters: [String: Any] = request.filterParameters ?? [:]
            return self.filtered(name: name, parameters: parameters)
        } else {
            return self
        }
    }
}

// MARK: UIImage
private extension UIImage {
    var isOpaque: Bool {
        return ![
            CGImageAlphaInfo.first,
            CGImageAlphaInfo.last,
            CGImageAlphaInfo.premultipliedFirst,
            CGImageAlphaInfo.premultipliedLast
            ].contains(self.cgImage?.alphaInfo)
    }
    
    func circled() -> UIImage {
        var image: UIImage = self
        let radius: CGFloat = min(self.size.width, self.size.height) / 2.0
        if self.size.width != self.size.height {
            let size: CGFloat = min(self.size.width, self.size.height)
            image = image.scaled(toFill: CGSize(width: size, height: size))
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, self.isOpaque, self.scale)
        let path = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: image.size),
            cornerRadius: radius)
        path.addClip()
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        image = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        return image
    }
    
    func filtered(name: String,
                  parameters: [String: Any] = [:]) -> UIImage {
        var _image: CIImage? = self.ciImage
        if _image == nil, let cgImage = self.cgImage {
            _image = CIImage(cgImage: cgImage)
        }
        guard let image: CIImage = _image else { return self }
        let context = CIContext(options: [.priorityRequestLow: true])
        var parameters: [String: Any] = parameters
        parameters[kCIInputImageKey] = image
        guard let filter: CIFilter = CIFilter(name: name, parameters: parameters) else { return self }
        guard let output: CIImage = filter.outputImage else { return self }
        guard let cgImage: CGImage = context.createCGImage(output, from: output.extent) else { return self }
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }
    
    func rounded(radius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, self.isOpaque, self.scale)
        let path = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: self.size),
            cornerRadius: radius)
        path.addClip()
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return image
    }
    
    func scaled(toFit size: CGSize) -> UIImage {
        guard size.width > 0 && size.height > 0 else { return self }
        let oldRatio: CGFloat = self.size.width / self.size.height
        let newRatio: CGFloat = size.width / size.height
        let factor: CGFloat = oldRatio > newRatio
            ? size.width / self.size.width
            : size.height / self.size.height
        let newSize: CGSize = CGSize(
            width: self.size.width * factor,
            height: self.size.height * factor)
        let newOrigin = CGPoint(
            x: (size.width - newSize.width) / 2.0,
            y: (size.height - newSize.height) / 2.0)
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, self.scale)
        self.draw(in: CGRect(origin: newOrigin, size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func scaled(toFill size: CGSize) -> UIImage {
        guard size.width > 0 && size.height > 0 else { return self }
        let oldRatio: CGFloat = self.size.width / self.size.height
        let newRatio: CGFloat = size.width / size.height
        let factor: CGFloat = oldRatio > newRatio
            ? size.height / self.size.height
            : size.width / self.size.width
        let newSize = CGSize(
            width: self.size.width * factor,
            height: self.size.height * factor)
        let newOrigin = CGPoint(
            x: (size.width - newSize.width) / 2.0,
            y: (size.height - newSize.height) / 2.0)
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, self.scale)
        self.draw(in: CGRect(origin: newOrigin, size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: UIImageView
public extension UIImageView {
    private static var requestKey: UInt8 = 0
    
    private var networkImages: NetworkImagesProtocol {
        let networkImages: NetworkImagesProtocol? = Injector.main.resolve()
        return networkImages ?? NetworkImages()
    }
    
    private var request: NetworkImageRequest? {
        get { return objc_getAssociatedObject(self, &Self.requestKey) as? NetworkImageRequest }
        set { objc_setAssociatedObject(self, &Self.requestKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func setImage(request: NetworkImageRequest,
                  onProgress: NetworkImagesOnProgress? = nil,
                  onSuccess: NetworkImagesOnSuccess? = nil,
                  onError: NetworkImagesOnError? = nil,
                  onCompletion: NetworkImagesOnCompletion? = nil) {
        request.dispatchQueue = .main
        DispatchQueue.global().async {
            self.networkImages.image(
                request: request,
                onProgress: onProgress,
                onSuccess: onSuccess,
                onError: onError,
                onCompletion: { [weak self] (image: UIImage?, error: NetworkError?) in
                    guard let `self` = self else { return }
                    self.image = image
                    onCompletion?(image, error)
            })
        }
        self.request = request
    }
    
    func cancel() {
        self.request?.cancel()
    }
}
