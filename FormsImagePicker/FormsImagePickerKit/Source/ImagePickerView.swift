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

// MARK: ImagePickerViewTranslation
public protocol ImagePickerViewTranslation {
    var chooseSource: String { get }
    var cancel: String { get }
    var camera: String { get }
    var photoLibrary: String { get }
    var savedPhotosAlbum: String { get }
}

public struct DefaultImagePickerViewTranslation: ImagePickerViewTranslation {
    public let chooseSource: String = "Choose source"
    public let cancel: String = "Cancel"
    public let camera: String = "Camera"
    public let photoLibrary: String = "Photo library"
    public let savedPhotosAlbum: String = "Saved photos album"
}

extension ImagePickerView {
    fileprivate typealias Action = (ImagePickerViewController.Type, UIViewController, ImagePickerRequest, ImagePicker.OnSelect?, ImagePicker.OnFail?, ImagePicker.OnCancel?) -> Void
    
    internal static func showActionsAlert(picker: ImagePickerViewController.Type,
                                          on controller: UIViewController,
                                          request: ImagePickerRequest,
                                          onSelect: ImagePicker.OnSelect?,
                                          onFail: ImagePicker.OnFail?,
                                          onCancel: ImagePicker.OnCancel?) {
        let translations: ImagePickerViewTranslation = request.userInfo[.translations] as? ImagePickerViewTranslation ?? DefaultImagePickerViewTranslation()
        let actions: [ImagePickerActionItem] = self.actions(request: request, translations: translations)
        guard !actions.isEmpty else { return }
        guard actions.count > 1 else {
            actions[0].action(picker, controller, request, onSelect, onFail, onCancel)
            return
        }
        let alert: UIAlertController = UIAlertController(
            title: translations.chooseSource,
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
            title: translations.cancel,
            style: .cancel,
            handler: { _ in }))
        controller.present(alert, animated: true)
    }
    
    private static func actions(request: ImagePickerRequest,
                                translations: ImagePickerViewTranslation) -> [ImagePickerActionItem] {
        var actions: [ImagePickerActionItem] = []
        if request.source.contains(.camera) {
            actions.append(ImagePickerActionItem(
                title: translations.camera,
                action: Self.presentCamera))
        }
        if request.source.contains(.photoLibrary) {
            actions.append(ImagePickerActionItem(
                title: translations.photoLibrary,
                action: Self.presentPhotoLibrary))
        }
        if request.source.contains(.savedPhotosAlbum) {
            actions.append(ImagePickerActionItem(
                title: translations.savedPhotosAlbum,
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

// MARK: ImagePickerUserInfoKey
public enum ImagePickerUserInfoKey: String {
    case translations
}

// MARK: ImagePickerRequest
public class ImagePickerRequest {
    public var allowsEditing: Bool = false
    public var cropSize: CGSize? = nil
    public var mediaTypes: [ImagePickerMediaType] = []
    public var resizableCropArea: Bool = false
    public var source: [UIImagePickerController.SourceType] = [.camera, .photoLibrary]
    public var userInfo: [ImagePickerUserInfoKey: Any] = [:]
    
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
    func with(userInfo: [ImagePickerUserInfoKey: Any]) -> Self {
        self.userInfo = userInfo
        return self
    }
    func with(translations: ImagePickerViewTranslation?) -> Self {
        self.userInfo[.translations] = translations
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
