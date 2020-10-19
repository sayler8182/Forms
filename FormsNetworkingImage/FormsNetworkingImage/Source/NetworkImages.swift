//
//  NetworkImages.swift
//  FormsNetworking
//
//  Created by Konrad on 6/9/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsInjector
import FormsLogger
import FormsNetworking
import FormsUtils
import UIKit

public typealias NetworkImagesOnProgress = (_ size: Int64, _ totalSize: Int64, _ progress: Double) -> Void
public typealias NetworkImagesOnSuccess = (_ image: NetworkImage) -> Void
public typealias NetworkImagesOnError = (_ error: NetworkError) -> Void
public typealias NetworkImagesOnCompletion = (_ image: NetworkImage?, _ error: NetworkError?) -> Void

// MARK: NetworkImageType
public enum NetworkImageType {
    case cache
    case network
    case placeholder
}

// MARK: NetworkImageType
public class NetworkImage {
    public var image: UIImage
    public let type: NetworkImageType
    
    init?(_ image: UIImage?,
          _ type: NetworkImageType) {
        guard let image: UIImage = image else { return nil }
        self.image = image
        self.type = type
    }
}

// MARK: NetworkImageRequest
public class NetworkImageRequest: ExpressibleByStringLiteral {
    public let url: URL?
    public var id: String?
    
    public var cache: UIImage?
    public var dispatchQueue: DispatchQueue
    public var dispatchProgressQueue: DispatchQueue
    public var placeholder: UIImage?
    public var scale: CGFloat
    public var isStartAutoShimmer: Bool?
    public var isStopAutoShimmer: Bool?
    public var isTransformCache: Bool?
    public var isTransformPlaceholder: Bool?
    
    public var cornerRadius: CGFloat?
    public var filter: String?
    public var filterParameters: [String: Any]?
    public var isRounded: Bool?
    public var scaleToFit: CGSize?
    public var scaleToFill: CGSize?
    
    fileprivate var task: NetworkTask?
    private var _isCancelled: Bool = false
    public var isCancelled: Bool {
        return self._isCancelled || self.task?.isCancelled == true
    }
    
    public var isCached: Bool {
        return self.cache != nil
    }
    
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
        self._isCancelled = true
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
    func with(isAutoShimmer: Bool) -> Self {
        self.isStartAutoShimmer = isAutoShimmer
        self.isStopAutoShimmer = isAutoShimmer
        return self
    }
    func with(isStartAutoShimmer: Bool) -> Self {
        self.isStartAutoShimmer = isStartAutoShimmer
        return self
    }
    func with(isStopAutoShimmer: Bool) -> Self {
        self.isStopAutoShimmer = isStopAutoShimmer
        return self
    }
    func with(isTransformCache: Bool) -> Self {
        self.isTransformCache = isTransformCache
        return self
    }
    func with(isTransformPlaceholder: Bool) -> Self {
        self.isTransformPlaceholder = isTransformPlaceholder
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
public protocol NetworkImagesProtocol: class {
    var logger: Logger? { get set }
    var cache: NetworkCache? { get set }
    
    func image(request: NetworkImageRequest,
               onProgress: NetworkImagesOnProgress?,
               onSuccess: NetworkImagesOnSuccess?,
               onError: NetworkImagesOnError?,
               onCompletion: NetworkImagesOnCompletion?)
    func isCached(_ request: NetworkImageRequest) -> Bool
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

public extension NetworkImagesProtocol {
    func with(logger: Logger?) -> Self {
        self.logger = logger
        return self
    }
    func with(cache: NetworkCache?) -> Self {
        self.cache = cache
        return self
    }
}

// MARK: Images
public class NetworkImages: NetworkImagesProtocol {
    public var logger: Logger?
    public var cache: NetworkCache?
    
    public init() { }
    
    public func image(request: NetworkImageRequest,
                      onProgress: NetworkImagesOnProgress? = nil,
                      onSuccess: NetworkImagesOnSuccess? = nil,
                      onError: NetworkImagesOnError? = nil,
                      onCompletion: NetworkImagesOnCompletion? = nil) {
        self.fetchImage(
            request: request,
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
    
    public func isCached(_ request: NetworkImageRequest) -> Bool {
        guard request.cache == nil else { return false }
        guard let url: URL = request.url else { return false }
        return NetworkImagesMethod(url: url)
            .with(logger: self.logger)
            .with(cache: self.cache)
            .isCached
    }
}

// MARK: NetworkImages
extension NetworkImages {
    private func fetchImage(request: NetworkImageRequest,
                            onProgress: NetworkImagesOnProgress?,
                            onSuccess: NetworkImagesOnSuccess?,
                            onError: NetworkImagesOnError?,
                            onCompletion: NetworkImagesOnCompletion?) {
        if let image = NetworkImage(request.cache, .cache) {
            image.transform(request, request.isTransformCache)
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
        } else if let image = NetworkImage(request.placeholder, .placeholder) {
            image.transform(request, request.isTransformPlaceholder)
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
        let isCached = self.isCached(request)
        let method = NetworkImagesMethod(url: url)
            .with(logger: self.logger)
            .with(cache: self.cache)
        let task = method.call(
            onProgress: { (size: Int64, totalSize: Int64, progress: Double) in
                guard let onProgress = onProgress else { return }
                guard self.isValid(request) else { return }
                request.dispatchProgressQueue.async {
                    onProgress(size, totalSize, progress)
                }
            }, onSuccess: { (data: Data) in
                guard self.isValid(request) else { return }
                let type: NetworkImageType = isCached ? .cache : .network
                if let image = NetworkImage(UIImage(data: data, scale: request.scale), type) {
                    image.transform(request, true)
                    if let onSuccess = onSuccess {
                        request.dispatchQueue.async {
                            onSuccess(image)
                        }
                    }
                } else if let onError = onError {
                    request.dispatchQueue.async {
                        onError(.incorrectResponseFormat)
                    }
                }
            }, onError: { (error: NetworkError) in
                guard let onError = onError else { return }
                guard self.isValid(request, onError: onError) else { return }
                request.dispatchQueue.async {
                    onError(error)
                }
            }, onCompletion: { (data: Data?, error: NetworkError?) in
                guard let onCompletion = onCompletion else { return }
                guard self.isValid(request, onCompletion: onCompletion) else { return }
                if let data: Data = data {
                    let type: NetworkImageType = isCached ? .cache : .network
                    if let image = NetworkImage(UIImage(data: data, scale: request.scale), type) {
                        image.transform(request, true)
                        request.dispatchQueue.async {
                            onCompletion(image, nil)
                        }
                    } else {
                        let image = NetworkImage(request.placeholder, .placeholder)
                        image?.transform(request, request.isTransformPlaceholder)
                        request.dispatchQueue.async {
                            onCompletion(image, .incorrectResponseFormat)
                        }
                    }
                } else {
                    let image = NetworkImage(request.placeholder, .placeholder)
                    image?.transform(request, request.isTransformPlaceholder)
                    request.dispatchQueue.async {
                        onCompletion(image, error)
                    }
                }
            })
        return task
    }
    
    private func isValid(_ request: NetworkImageRequest,
                         onError: NetworkImagesOnError? = nil,
                         onCompletion: NetworkImagesOnCompletion? = nil) -> Bool {
        guard request.isCancelled else { return true }
        if let onError = onError {
            request.dispatchQueue.async {
                onError(.cancelled)
            }
        }
        if let onCompletion = onCompletion {
            request.dispatchQueue.async {
                onCompletion(nil, .cancelled)
            }
        }
        return false
    }
}

// MARK: NetworkImagesMethod
private class NetworkImagesMethod: NetworkMethod {
    var url: URL!
    
    init(url: URL) {
        self.url = url
    } 
}

// MARK: NetworkImage - Transform
fileprivate extension NetworkImage {
    func transform(_ request: NetworkImageRequest,
                   _ shouldTransform: Bool?) {
        guard shouldTransform == true else { return }
        self.image = self.image.transform(request, true)
    }
}

// MARK: UIImage - Transform
extension UIImage {
    fileprivate func transform(_ request: NetworkImageRequest,
                               _ shouldTransform: Bool?) -> UIImage {
        var image: UIImage = self
        guard shouldTransform == true else { return image }
        image = image.transformScale(request)
        image = image.transformRadius(request)
        image = image.transformFilter(request)
        return image
    }
    
    private func transformScale(_ request: NetworkImageRequest) -> UIImage {
        if let scale: CGSize = request.scaleToFit {
            return self.scaled(toFit: scale, scale: request.scale)
        } else if let scale: CGSize = request.scaleToFill {
            return self.scaled(toFill: scale, scale: request.scale)
        } else {
            return self
        }
    }
    
    private func transformRadius(_ request: NetworkImageRequest) -> UIImage {
        if let isRounded: Bool = request.isRounded,
           isRounded == true {
            return self.circled(scale: request.scale)
        } else if let radius: CGFloat = request.cornerRadius {
            return self.rounded(radius: radius, scale: request.scale)
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
    
    func circled(scale: CGFloat) -> UIImage {
        var image: UIImage = self
        let radius: CGFloat = min(self.size.width, self.size.height) / 2.0
        if self.size.width != self.size.height {
            let size: CGFloat = min(self.size.width, self.size.height)
            image = image.scaled(toFill: CGSize(width: size, height: size), scale: scale)
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
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
    
    func rounded(radius: CGFloat,
                 scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, self.isOpaque, scale)
        let path = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: self.size),
            cornerRadius: radius)
        path.addClip()
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return image
    }
    
    func scaled(toFit size: CGSize,
                scale: CGFloat) -> UIImage {
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
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, scale)
        self.draw(in: CGRect(origin: newOrigin, size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func scaled(toFill size: CGSize,
                scale: CGFloat) -> UIImage {
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
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, scale)
        self.draw(in: CGRect(origin: newOrigin, size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: UIImageView
public extension UIImageView {
    private static var requestKey: UInt8 = 0
    private static var requestIdKey: UInt8 = 0
    
    private var networkImages: NetworkImagesProtocol {
        let networkImages: NetworkImagesProtocol? = Injector.main.resolveOrDefault("FormsNetworkingImage")
        return networkImages ?? NetworkImages()
    }
    
    private var request: NetworkImageRequest? {
        get { return getObject(self, &Self.requestKey) }
        set { setObject(self, &Self.requestKey, newValue) }
    }
    private var requestId: String? {
        get { return getObject(self, &Self.requestIdKey) }
        set { setObject(self, &Self.requestIdKey, newValue) }
    }
    
    func setImage(request: NetworkImageRequest,
                  logger: Logger? = nil,
                  cache: NetworkCache? = nil,
                  onProgress: NetworkImagesOnProgress? = nil,
                  onSuccess: NetworkImagesOnSuccess? = nil,
                  onError: NetworkImagesOnError? = nil,
                  onCompletion: NetworkImagesOnCompletion? = nil) {
        self.requestId = UUID().uuidString
        request.id = self.requestId
        if let image = NetworkImage(request.cache, .cache) {
            onSuccess?(image)
            onCompletion?(image, nil)
        } else {
            DispatchQueue.global().async {
                let networkImages: NetworkImagesProtocol = self.networkImages
                let logger: Logger? = logger ?? networkImages.logger
                let cache: NetworkCache? = cache ?? networkImages.cache
                networkImages
                    .with(logger: logger)
                    .with(cache: cache)
                    .image(
                        request: request,
                        onProgress: onProgress,
                        onSuccess: onSuccess,
                        onError: onError,
                        onCompletion: onCompletion)
            }
        }
        self.request = request
    }
    
    func isValid(_ request: NetworkImageRequest) -> Bool {
        return request.id == self.requestId
    }
    
    func isCached(_ request: NetworkImageRequest) -> Bool {
        return self.networkImages.isCached(request)
    }
    
    func cancel() {
        self.requestId = UUID().uuidString
        self.request?.cancel()
    }
}
