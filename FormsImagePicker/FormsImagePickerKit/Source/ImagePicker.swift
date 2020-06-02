//
//  ImagePicker.swift
//  FormsImagePicker
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import MobileCoreServices
import UIKit

// MARK: ImagePickerMediaType
public enum ImagePickerMediaType {
    case image
    case video
    
    public var kUTType: String {
        switch self {
        case .image: return kUTTypeImage as String
        case .video: return kUTTypeMovie as String
        }
    }
}

// MARK: ImagePicker
public struct ImagePickerData {
    public struct Image {
        public let image: UIImage
        public let imageURL: URL
    }
    public struct Video {
        public let videoURL: URL
    }
    
    public let images: [Image]
    public let videos: [Video]
}

// MARK: ImagePicker
public enum ImagePicker {
    public typealias OnSelect = ((_ data: ImagePickerData) -> Void)
    public typealias OnCancel = (() -> Void)
    
    public static func pick(on controller: UIViewController?,
                            pickerType: ImagePickerView.Type = SystemImagePickerView.self,
                            allowsEditing: Bool = true,
                            mediaTypes: [ImagePickerMediaType] = [.image],
                            onSelect: OnSelect?,
                            onCancel: OnCancel? = nil) {
        guard let controller: UIViewController = controller else { return }
        pickerType.present(
            on: controller,
            allowsEditing: allowsEditing,
            mediaTypes: mediaTypes,
            onSelect: onSelect,
            onCancel: onCancel)
    }
}
