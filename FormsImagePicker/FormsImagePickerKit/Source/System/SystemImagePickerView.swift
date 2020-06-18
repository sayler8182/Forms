//
//  SystemImagePickerView.swift
//  FormsImagePicker
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsPermissions
import MobileCoreServices
import UIKit

// MARK: SystemImagePickerView
public class SystemImagePickerView: ImagePickerView {
    public static func present(on controller: UIViewController,
                               request: ImagePickerRequest,
                               onSelect: ImagePicker.OnSelect?,
                               onFail: ImagePicker.OnFail?,
                               onCancel: ImagePicker.OnCancel?) {
        Self.showActionsAlert(
            picker: SystemImagePickerController.self,
            on: controller,
            request: request,
            onSelect: onSelect,
            onFail: onFail,
            onCancel: onCancel)
    } 
}

// MARK: SystemImagePickerController
internal class SystemImagePickerController: UIImagePickerController, ImagePickerViewController {
    private lazy var imagePickerDelegate = SystemImagePickerControllerDelegate(self) // swiftlint:disable:this weak_delegate
    fileprivate var onSelect: ImagePicker.OnSelect?
    fileprivate var onFail: ImagePicker.OnFail?
    fileprivate var onCancel: ImagePicker.OnCancel?
    
    internal func configure(sourceType: UIImagePickerController.SourceType,
                            request: ImagePickerRequest,
                            onSelect: ImagePicker.OnSelect?,
                            onFail: ImagePicker.OnFail?,
                            onCancel: ImagePicker.OnCancel?) {
        self.delegate = self.imagePickerDelegate
        self.sourceType = sourceType
        self.allowsEditing = request.allowsEditing
        self.mediaTypes = request.mediaTypes.map { $0.kUTType }
        self.onSelect = onSelect
        self.onFail = onFail
        self.onCancel = onCancel
    }
}

// MARK: SystemImagePickerControllerDelegate
private class SystemImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private weak var controller: SystemImagePickerController?
    
    init(_ controller: SystemImagePickerController) {
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
        if let url: URL = info.url {
            videos.append(ImagePickerData.Video(
                videoURL: url))
        }
        let imagePickerData = ImagePickerData(
            images: images,
            videos: videos)
        picker.dismiss(animated: true) {
            self.controller?.onSelect?(imagePickerData)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.controller?.onCancel?()
        }
    }
}
