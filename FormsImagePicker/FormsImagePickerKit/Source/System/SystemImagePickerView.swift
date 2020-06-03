//
//  SystemImagePickerView.swift
//  FormsImagePicker
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import MobileCoreServices
import UIKit

// MARK: SystemImagePickerView
public class SystemImagePickerView: ImagePickerView {
    public static func present(on controller: UIViewController,
                               allowsEditing: Bool,
                               mediaTypes: [ImagePickerMediaType],
                               onSelect: ImagePicker.OnSelect?,
                               onCancel: ImagePicker.OnCancel?) {
        let alert: UIAlertController = UIAlertController(
            title: "Choose source",
            message: nil,
            preferredStyle: .actionSheet)
        
        // action
        alert.addAction(UIAlertAction(
            title: "Camera",
            style: .default,
            handler: { _ in
                let imagePicker = SystemImagePickerController()
                imagePicker.configure(
                    sourceType: UIImagePickerController.SourceType.camera,
                    allowsEditing: allowsEditing,
                    mediaTypes: mediaTypes,
                    onSelect: onSelect,
                    onCancel: onCancel)
                controller.present(imagePicker, animated: true)
        }))
        alert.addAction(UIAlertAction(
            title: "Gallery",
            style: .default,
            handler: { _ in
                let imagePicker = SystemImagePickerController()
                imagePicker.configure(
                    sourceType: UIImagePickerController.SourceType.photoLibrary,
                    allowsEditing: allowsEditing,
                    mediaTypes: mediaTypes,
                    onSelect: onSelect,
                    onCancel: onCancel)
                controller.present(imagePicker, animated: true)
        }))
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .destructive,
            handler: { _ in }))
        controller.present(alert, animated: true)
    }
}

// MARK: SystemImagePickerController
private class SystemImagePickerController: UIImagePickerController {
    private lazy var imagePickerDelegate = SystemImagePickerControllerDelegate(self) // swiftlint:disable:this weak_delegate
    fileprivate var onSelect: ImagePicker.OnSelect?
    fileprivate var onCancel: ImagePicker.OnCancel?
    
    fileprivate func configure(sourceType: UIImagePickerController.SourceType,
                               allowsEditing: Bool = false,
                               mediaTypes: [ImagePickerMediaType],
                               onSelect: ImagePicker.OnSelect?,
                               onCancel: ImagePicker.OnCancel?) {
        self.delegate = self.imagePickerDelegate
        self.sourceType = sourceType
        self.allowsEditing = allowsEditing
        self.mediaTypes = mediaTypes.map { $0.kUTType }
        self.onSelect = onSelect
        self.onCancel = onCancel
    }
}

// MARK: [UIImagePickerController.InfoKey: Any]
private extension Dictionary where Key == UIImagePickerController.InfoKey {
    var image: UIImage? {
        if let image: UIImage = self[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image: UIImage = self[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
    
    var url: URL? {
        if #available(iOS 11.0, *) {
            if let url: URL = self[UIImagePickerController.InfoKey.imageURL] as? URL {
                return url
            } else if let url: URL = self[UIImagePickerController.InfoKey.mediaURL] as? URL {
                return url
            } else {
                return nil
            }
        } else {
            return self[UIImagePickerController.InfoKey.mediaURL] as? URL
        }
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
        if let image: UIImage = info.image,
            let url: URL = info.url {
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
