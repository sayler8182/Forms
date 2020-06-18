//
//  WDImagePickerView.swift
//  FormsImagePicker
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsPermissions
import MobileCoreServices
import UIKit

// MARK: WDImagePickerView
public class WDImagePickerView: ImagePickerView {
    public static func present(on controller: UIViewController,
                               request: ImagePickerRequest,
                               onSelect: ImagePicker.OnSelect?,
                               onFail: ImagePicker.OnFail?,
                               onCancel: ImagePicker.OnCancel?) {
        Self.showActionsAlert(
            picker: WDImagePickerController.self,
            on: controller,
            request: request,
            onSelect: onSelect,
            onFail: onFail,
            onCancel: onCancel)
    }
}

// MARK: WDImagePickerController
internal class WDImagePickerController: UIImagePickerController, ImagePickerViewController {
    private lazy var imagePickerDelegate = WDImagePickerControllerDelegate(self) // swiftlint:disable:this weak_delegate
    fileprivate var request: ImagePickerRequest!
    
    fileprivate var onSelect: ImagePicker.OnSelect?
    fileprivate var onFail: ImagePicker.OnFail?
    fileprivate var onCancel: ImagePicker.OnCancel?
    
    internal func configure(sourceType: UIImagePickerController.SourceType,
                            request: ImagePickerRequest,
                            onSelect: ImagePicker.OnSelect?,
                            onFail: ImagePicker.OnFail?,
                            onCancel: ImagePicker.OnCancel?) {
        self.request = request
        self.delegate = self.imagePickerDelegate
        self.sourceType = sourceType
        self.allowsEditing = false
        self.mediaTypes = request.mediaTypes.map { $0.kUTType }
        self.onSelect = onSelect
        self.onFail = onFail
        self.onCancel = onCancel
    }
    
    fileprivate func processData(_ data: ImagePickerData) {
        guard self.request.allowsEditing && data.hasOnlyOneImage else {
            self.dismiss(animated: true) {
                self.onSelect?(data)
            }
            return
        }
        self.cropImage(data)
    }
    
    fileprivate func cropImage(_ data: ImagePickerData) {
        let controller = WDImageCropViewController(
            source: data,
            request: self.request,
            delegate: self.imagePickerDelegate)
        self.pushViewController(controller, animated: true)
    }
}

// MARK: WDImageImagePickerControllerDelegate
private class WDImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WDImageCropControllerDelegate {
    private weak var controller: WDImagePickerController?
    
    init(_ controller: WDImagePickerController) {
        self.controller = controller
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var images: [ImagePickerData.Image] = []
        if let image: UIImage = info.image {
            let url: URL? = info.url
            images.append(ImagePickerData.Image(
                image: image,
                imageURL: url))
        }
        var videos: [ImagePickerData.Video] = []
        if let url: URL = info.url,
            url.isVideo {
            videos.append(ImagePickerData.Video(
                videoURL: url))
        }
        let imagePickerData = ImagePickerData(
            images: images,
            videos: videos)
        self.controller?.processData(imagePickerData)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.controller?.onCancel?()
        }
    }
    
    func imageCropController(_ data: ImagePickerData) {
        self.controller?.dismiss(animated: true) {
            self.controller?.onSelect?(data)
        }
    }
}
