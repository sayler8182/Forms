//
//  DemoImagePickerKitSystemViewController.swift
//  FormsDemo
//
//  Created by Konrad on 4/28/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Forms
import FormsImagePickerKit
import FormsToastKit
import UIKit

// MARK: DemoImagePickerKitSystemViewController
class DemoImagePickerKitSystemViewController: FormsTableViewController {
    private let itemsScroll = Components.container.scroll()
        .with(scrollDirection: .horizontal)
    private let chooseImageButton = Components.button.default()
        .with(title: "Choose Image")
    private let chooseVideoButton = Components.button.default()
        .with(title: "Choose Video")
    
    private let divider = Components.utils.divider()
        .with(height: 5.0)
    
    override func setupContent() {
        super.setupContent()
        self.build([
            self.itemsScroll,
            self.chooseImageButton,
            self.chooseVideoButton
        ], divider: self.divider)
    }
    
    override func setupActions() {
        super.setupActions()
        self.chooseImageButton.onClick = {
            let request = ImagePickerRequest()
                .with(allowsEditing: true)
                .with(mediaTypes: [.image])
            ImagePicker.pick(
                on: self,
                pickerType: SystemImagePickerView.self,
                request: request,
                onSelect: { [unowned self] (data) in
                    self.updateImages(data)
                },
                onFail: { [unowned self] in
                    Toast.info()
                        .with(title: "Fail")
                        .show(in: self.navigationController)
                },
                onCancel: { [unowned self] in
                    Toast.info()
                        .with(title: "Cancel")
                        .show(in: self.navigationController)
            })
        }
        self.chooseVideoButton.onClick = {
            let request = ImagePickerRequest()
                .with(allowsEditing: true)
                .with(mediaTypes: [.video])
            ImagePicker.pick(
                on: self,
                pickerType: SystemImagePickerView.self,
                request: request,
                onSelect: { [unowned self] (data) in
                    self.updateVideos(data)
                },
                onFail: { [unowned self] in
                    Toast.info()
                        .with(title: "Fail")
                        .show(in: self.navigationController)     
                },
                onCancel: { [unowned self] in
                    Toast.info()
                        .with(title: "Cancel")
                        .show(in: self.navigationController)
            })
        }
    }
    
    private func updateImages(_ data: ImagePickerData) {
        var items: [FormsComponent] = []
        for image in data.images {
            let item = Components.image.default()
                .with(aspectRatio: 1.0)
                .with(contentMode: .scaleAspectFill)
                .with(height: 100.0)
                .with(image: image.image)
            items.append(item)
        }
        self.itemsScroll.items = items
    }
    
    private func updateVideos(_ data: ImagePickerData) {
        self.itemsScroll.items = []
        Toast.success()
            .with(title: "Videos picked: \(data.videos.count)")
            .show(in: self.navigationController)
    }
}
