//
//  ImagePickerView.swift
//  ImagePicker
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: ImagePickerView
public protocol ImagePickerView {
    static func present(on controller: UIViewController,
                        allowsEditing: Bool,
                        mediaTypes: [ImagePickerMediaType],
                        onSelect: ImagePicker.OnSelect?,
                        onCancel: ImagePicker.OnCancel?)
}
