//
//  WDImageCropView.swift
//  FormsImagePicker
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import QuartzCore
import UIKit

// MARK: ScrollView
private class ScrollView: UIScrollView {
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let zoomView: UIView = self.delegate?.viewForZooming?(in: self) else { return }
        let boundsSize: CGSize = self.bounds.size
        var frameToCenter: CGRect = zoomView.frame
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        zoomView.frame = frameToCenter
    }
}

// MARK: WDImageCropView
internal class WDImageCropView: UIView, UIScrollViewDelegate {
    fileprivate var scrollView: UIScrollView!
    fileprivate var imageView: UIImageView!
    fileprivate var cropOverlayView: WDImageCropOverlayView!
    
    var resizableCropArea: Bool = false
    
    fileprivate var xOffset: CGFloat!
    fileprivate var yOffset: CGFloat!
    
    var imageToCrop: UIImage? {
        get { return self.imageView.image }
        set { self.imageView.image = newValue }
    }
    
    var cropSize: CGSize {
        get { return self.cropOverlayView.cropSize }
        set {
            if let view = self.cropOverlayView {
                view.cropSize = newValue
                self.scrollView.setZoomScale(1.0, animated: false)
            } else {
                if self.resizableCropArea {
                    self.cropOverlayView = WDImageResizableCropOverlayView(
                        frame: self.bounds,
                        initialContentSize: CGSize(width: newValue.width, height: newValue.height))
                } else {
                    self.cropOverlayView = WDImageCropOverlayView(frame: self.bounds)
                }
                self.cropOverlayView.cropSize = newValue
                self.addSubview(self.cropOverlayView)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.black
        self.scrollView = ScrollView(frame: frame)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        self.scrollView.clipsToBounds = false
        self.scrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0)
        self.scrollView.backgroundColor = UIColor.clear
        self.addSubview(self.scrollView)
        
        self.imageView = UIImageView(frame: self.scrollView.frame)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.backgroundColor = UIColor.black
        self.scrollView.addSubview(self.imageView)
        
        self.scrollView.minimumZoomScale = self.scrollView.frame.width / self.scrollView.frame.height
        self.scrollView.maximumZoomScale = 20
        self.scrollView.setZoomScale(1.0, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let resizableCropView = self.cropOverlayView as? WDImageResizableCropOverlayView else { return self.scrollView }
        let outerFrame: CGRect = resizableCropView.cropBorderView.frame.insetBy(dx: -10, dy: -10)
        guard outerFrame.contains(point) else { return self.scrollView }
        if resizableCropView.cropBorderView.frame.size.width < 60 ||
            resizableCropView.cropBorderView.frame.size.height < 60 {
            return super.hitTest(point, with: event)
        }
        let innerTouchFrame = resizableCropView.cropBorderView.frame.insetBy(dx: 30, dy: 30)
        guard !innerTouchFrame.contains(point) else { return self.scrollView }
        return super.hitTest(point, with: event)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let image: UIImage = self.imageToCrop else { return }
        self.xOffset = floor((self.bounds.width - self.cropSize.width) * 0.5)
        self.yOffset = floor((self.bounds.height - 54.0 - UIView.safeArea.bottom - self.cropSize.height) * 0.5)
        let height: CGFloat = image.size.height
        let width: CGFloat = image.size.width
        var factor: CGFloat = 0
        var factoredHeight: CGFloat = 0
        var factoredWidth: CGFloat = 0
        
        if width > height {
            factor = width / self.cropSize.width
            factoredWidth = self.cropSize.width
            factoredHeight = height / factor
        } else {
            factor = height / self.cropSize.height
            factoredWidth = width / factor
            factoredHeight = self.cropSize.height
        }
        
        self.cropOverlayView.frame = self.bounds
        self.scrollView.frame = CGRect(
            x: self.xOffset,
            y: self.yOffset,
            width: self.cropSize.width,
            height: self.cropSize.height)
        self.scrollView.contentSize = CGSize(width: self.cropSize.width, height: self.cropSize.height)
        self.imageView.frame = CGRect(
            x: 0,
            y: floor((self.cropSize.height - factoredHeight) * 0.5),
            width: factoredWidth,
            height: factoredHeight)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func croppedImage() -> UIImage? {
        guard let image: UIImage = self.imageToCrop else { return nil }
        var visibleRect: CGRect = self.resizableCropArea
            ? self.calcVisibleRectForResizeableCropArea()
            : self.calcVisibleRectForCropArea()
        let rectTransform: CGAffineTransform = self.orientationTransformedRectOfImage(image)
        visibleRect = visibleRect.applying(rectTransform)
        guard let cgImage: CGImage = image.cgImage?.cropping(to: visibleRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    fileprivate func calcVisibleRectForResizeableCropArea() -> CGRect {
        guard let cropOverlayView = self.cropOverlayView as? WDImageResizableCropOverlayView else { return CGRect.zero }
        guard let image: UIImage = self.imageToCrop else { return CGRect.zero }
        var sizeScale: CGFloat = image.size.width / self.imageView.frame.size.width
        sizeScale *= self.scrollView.zoomScale
        let visibleRect = cropOverlayView.contentView.convert(cropOverlayView.contentView.bounds, to: self.imageView)
        return self.scaleRect(visibleRect, scale: sizeScale)
    }
    
    fileprivate func calcVisibleRectForCropArea() -> CGRect {
        guard let image: UIImage = self.imageToCrop else { return CGRect.zero }
        let scaleWidth: CGFloat = image.size.width / self.cropSize.width
        let scaleHeight: CGFloat = image.size.height / self.cropSize.height
        var scale: CGFloat = 0
        
        if self.cropSize.width == self.cropSize.height {
            scale = max(scaleWidth, scaleHeight)
        } else if self.cropSize.width > self.cropSize.height {
            scale = image.size.width < image.size.height ?
                max(scaleWidth, scaleHeight) :
                min(scaleWidth, scaleHeight)
        } else {
            scale = image.size.width < image.size.height ?
                min(scaleWidth, scaleHeight) :
                max(scaleWidth, scaleHeight)
        }
        let visibleRect = self.scrollView.convert(self.scrollView.bounds, to: self.imageView)
        return self.scaleRect(visibleRect, scale: scale)
    }
    
    fileprivate func orientationTransformedRectOfImage(_ image: UIImage) -> CGAffineTransform {
        switch image.imageOrientation {
        case .left:
            return CGAffineTransform(rotationAngle: CGFloat.pi / 2).translatedBy(x: 0, y: -image.size.height)
                .scaledBy(x: image.scale, y: image.scale)
        case .right:
            return CGAffineTransform(rotationAngle: -CGFloat.pi / 2).translatedBy(x: -image.size.width, y: 0)
                .scaledBy(x: image.scale, y: image.scale)
        case .down:
            return CGAffineTransform(rotationAngle: -CGFloat.pi / 2).translatedBy(x: -image.size.width, y: -image.size.height)
                .scaledBy(x: image.scale, y: image.scale)
        default:
            return CGAffineTransform.identity
                .scaledBy(x: image.scale, y: image.scale)
        }
    }
    
    fileprivate func scaleRect(_ rect: CGRect, scale: CGFloat) -> CGRect {
        return CGRect(
            x: rect.origin.x * scale,
            y: rect.origin.y * scale,
            width: rect.size.width * scale,
            height: rect.size.height * scale)
    }
}
