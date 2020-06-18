//
//  ImagePickerView.swift
//  FormsImagePicker
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import FormsPermissions
import UIKit

// MARK: ImagePickerView
public protocol ImagePickerView {
    static func present(on controller: UIViewController,
                        request: ImagePickerRequest,
                        onSelect: ImagePicker.OnSelect?,
                        onFail: ImagePicker.OnFail?,
                        onCancel: ImagePicker.OnCancel?)
}

// MARK: ImagePickerViewController
public protocol ImagePickerViewController {
    init()
    func configure(sourceType: UIImagePickerController.SourceType,
                   request: ImagePickerRequest,
                   onSelect: ImagePicker.OnSelect?,
                   onFail: ImagePicker.OnFail?,
                   onCancel: ImagePicker.OnCancel?)
}

// MARK: ImagePickerActionItem
private struct ImagePickerActionItem {
    let title: String
    let action: ImagePickerView.Action
}

extension ImagePickerView {
    fileprivate typealias Action = (ImagePickerViewController.Type, UIViewController, ImagePickerRequest, ImagePicker.OnSelect?, ImagePicker.OnFail?, ImagePicker.OnCancel?) -> Void
    
    internal static func showActionsAlert(picker: ImagePickerViewController.Type,
                                          on controller: UIViewController,
                                          request: ImagePickerRequest,
                                          onSelect: ImagePicker.OnSelect?,
                                          onFail: ImagePicker.OnFail?,
                                          onCancel: ImagePicker.OnCancel?) {
        let actions: [ImagePickerActionItem] = self.actions(request: request)
        guard !actions.isEmpty else { return }
        guard actions.count > 1 else {
            actions[0].action(picker, controller, request, onSelect, onFail, onCancel)
            return
        }
        let alert: UIAlertController = UIAlertController(
            title: "Choose source",
            message: nil,
            preferredStyle: .actionSheet)
        for action in actions {
            alert.addAction(UIAlertAction(
                title: action.title,
                style: .default,
                handler: { _ in
                    action.action(picker, controller, request, onSelect, onFail, onCancel)
            }))
        }
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .destructive,
            handler: { _ in }))
        controller.present(alert, animated: true)
    }
    
    private static func actions(request: ImagePickerRequest) -> [ImagePickerActionItem] {
        var actions: [ImagePickerActionItem] = []
        if request.source.contains(.camera) {
            actions.append(ImagePickerActionItem(
                title: "Camera",
                action: Self.presentCamera))
        }
        if request.source.contains(.photoLibrary) {
            actions.append(ImagePickerActionItem(
                title: "Photo library",
                action: Self.presentPhotoLibrary))
        }
        if request.source.contains(.savedPhotosAlbum) {
            actions.append(ImagePickerActionItem(
                title: "Photo library",
                action: Self.presentSavedPhotosAlbum))
        }
        return actions
    }
    
    private static func presentCamera(picker: ImagePickerViewController.Type,
                                      on controller: UIViewController,
                                      request: ImagePickerRequest,
                                      onSelect: ImagePicker.OnSelect?,
                                      onFail: ImagePicker.OnFail?,
                                      onCancel: ImagePicker.OnCancel?) {
        Permissions.camera.status { (status) in
            guard !status.isRestricted else {
                onFail?()
                return
            }
            let imagePicker = picker.init()
            imagePicker.configure(
                sourceType: Self.cameraSource,
                request: request,
                onSelect: onSelect,
                onFail: onFail,
                onCancel: onCancel)
            guard let imagePickerController = imagePicker as? UIViewController else { return }
            controller.present(imagePickerController, animated: true)
        }
    }
    
    private static func presentPhotoLibrary(picker: ImagePickerViewController.Type,
                                            on controller: UIViewController,
                                            request: ImagePickerRequest,
                                            onSelect: ImagePicker.OnSelect?,
                                            onFail: ImagePicker.OnFail?,
                                            onCancel: ImagePicker.OnCancel?) {
        Permissions.photoLibrary.status { (status) in
            guard !status.isRestricted else {
                onFail?()
                return
            }
            let imagePicker = picker.init()
            imagePicker.configure(
                sourceType: Self.photoLibrarySource,
                request: request,
                onSelect: onSelect,
                onFail: onFail,
                onCancel: onCancel)
            guard let imagePickerController = imagePicker as? UIViewController else { return }
            controller.present(imagePickerController, animated: true)
        }
    }
    
    private static func presentSavedPhotosAlbum(picker: ImagePickerViewController.Type,
                                                on controller: UIViewController,
                                                request: ImagePickerRequest,
                                                onSelect: ImagePicker.OnSelect?,
                                                onFail: ImagePicker.OnFail?,
                                                onCancel: ImagePicker.OnCancel?) {
        Permissions.photoLibrary.status { (status) in
            guard !status.isRestricted else {
                onFail?()
                return
            }
            let imagePicker = picker.init()
            imagePicker.configure(
                sourceType: Self.savedPhotosAlbumSource,
                request: request,
                onSelect: onSelect,
                onFail: onFail,
                onCancel: onCancel)
            guard let imagePickerController = imagePicker as? UIViewController else { return }
            controller.present(imagePickerController, animated: true)
        }
    }
}

public extension ImagePickerView {
    static var cameraSource: UIImagePickerController.SourceType {
        #if targetEnvironment(simulator)
        return UIImagePickerController.SourceType.photoLibrary
        #else
        return UIImagePickerController.SourceType.camera
        #endif
    }
    static var photoLibrarySource: UIImagePickerController.SourceType {
        return UIImagePickerController.SourceType.photoLibrary
    }
    static var savedPhotosAlbumSource: UIImagePickerController.SourceType {
        return UIImagePickerController.SourceType.savedPhotosAlbum
    }
}

// MARK: ImagePickerRequest
public class ImagePickerRequest {
    public var allowsEditing: Bool = false
    public var cropSize: CGSize? = nil
    public var mediaTypes: [ImagePickerMediaType] = []
    public var resizableCropArea: Bool = false
    public var source: [UIImagePickerController.SourceType] = [.camera, .photoLibrary]
    
    public init() { }
}
public extension ImagePickerRequest {
    func with(allowsEditing: Bool) -> Self {
        self.allowsEditing = allowsEditing
        return self
    }
    func with(cropSize: CGSize?) -> Self {
        self.cropSize = cropSize
        return self
    }
    func with(mediaTypes: [ImagePickerMediaType]) -> Self {
        self.mediaTypes = mediaTypes
        return self
    }
    func with(resizableCropArea: Bool) -> Self {
        self.resizableCropArea = resizableCropArea
        return self
    }
    func with(source: [UIImagePickerController.SourceType]) -> Self {
        self.source = source
        return self
    }
}

// MARK: [UIImagePickerController.InfoKey: Any]
internal extension Dictionary where Key == UIImagePickerController.InfoKey {
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

// MARK: URL
internal extension URL {
    var isImage: Bool {
        let lastComponent: String = self.lastPathComponent
        return ["jpeg", "jpg"].contains(lastComponent)
    }
    
    var isVideo: Bool {
        let lastComponent: String = self.lastPathComponent
        return ["mov"].contains(lastComponent)
    }
}
