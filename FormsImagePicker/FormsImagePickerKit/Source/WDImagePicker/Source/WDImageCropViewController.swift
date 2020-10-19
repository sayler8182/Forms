//
//  WDImageCropViewController.swift
//  WDImagePicker
//
//  Created by Wu Di on 27/8/15.
//  Copyright (c) 2015 Wu Di. All rights reserved.
//

import CoreGraphics
import Forms
import FormsAnchor
import UIKit

// MARK: WDImageCropControllerDelegate
internal protocol WDImageCropControllerDelegate: class {
    func imageCropController(_ data: ImagePickerData)
}

// MARK: WDImageCropViewController
internal class WDImageCropViewController: UIViewController, Themeable {
    fileprivate var source: ImagePickerData
    fileprivate var request: ImagePickerRequest
    fileprivate weak var delegate: WDImageCropControllerDelegate?

    fileprivate let imageCropView: WDImageCropView = WDImageCropView()
    fileprivate let toolbarView: UIView = UIView()
    fileprivate let toolbar: UIToolbar = UIToolbar()
    fileprivate let useButton: UIButton = UIButton()
    fileprivate let cancelButton: UIButton = UIButton()
    
    init(source: ImagePickerData,
         request: ImagePickerRequest,
         delegate: WDImageCropControllerDelegate) {
        self.source = source
        self.request = request
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.setupContent()
        self.setupNavigationBar()
        self.setupCropView()
        self.setupCancelButton()
        self.setupUseButton()
        self.setupToolbar()
    }
    
    private func setupContent() {
        Theme.register(self)
    }
    
    func setTheme() {
        self.cancelButton.setTitleColor(Theme.Colors.primaryDark, for: .normal)
        self.useButton.setTitleColor(Theme.Colors.primaryDark, for: .normal)
        self.toolbarView.backgroundColor = Theme.Colors.primaryLight
    }
    
    private func setupNavigationBar() {
        self.title = "Choose Photo"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTouchUpInside))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Use",
            style: .plain,
            target: self,
            action: #selector(useTouchUpInside))
    }

    private func setupCropView() {
        self.imageCropView.frame = self.view.bounds
        self.imageCropView.imageToCrop = self.source.image?.image
        self.imageCropView.resizableCropArea = self.request.resizableCropArea
        self.imageCropView.cropSize = self.request.cropSize ?? self.view.bounds.size
        self.view.addSubview(self.imageCropView, with: [
            Anchor.to(self.view).fill
        ])
    }

    private func setupCancelButton() {
        self.cancelButton.titleLabel?.font = Theme.Fonts.bold(ofSize: 16)
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.setTitleColor(Theme.Colors.primaryDark, for: .normal)
        self.cancelButton.addTarget(self, action: #selector(cancelTouchUpInside), for: .touchUpInside)
    }

    private func setupUseButton() {
        self.useButton.titleLabel?.font = Theme.Fonts.bold(ofSize: 16)
        self.useButton.setTitle("Use", for: .normal)
        self.useButton.setTitleColor(Theme.Colors.primaryDark, for: .normal)
        self.useButton.addTarget(self, action: #selector(useTouchUpInside), for: .touchUpInside)
    }

    private func setupToolbar() {
        self.toolbarView.backgroundColor = Theme.Colors.primaryLight
        self.view.addSubview(self.toolbarView, with: [
            Anchor.to(self.view).horizontal,
            Anchor.to(self.view).bottom
        ])
        self.toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 54.0)
        self.toolbarView.addSubview(self.toolbar, with: [
            Anchor.to(self.toolbarView).top,
            Anchor.to(self.toolbarView).horizontal,
            Anchor.to(self.toolbarView).height(54.0),
            Anchor.to(self.toolbarView).bottom.offset(UIView.safeArea.bottom)
        ])
        let cancel = UIBarButtonItem(customView: self.cancelButton)
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let use = UIBarButtonItem(customView: self.useButton)
        self.toolbar.setItems([cancel, flex, use], animated: false)
    }
    
    @objc
    private func cancelTouchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc
    private func useTouchUpInside(_ sender: UIButton) {
        let images: [ImagePickerData.Image] = [
            self.imageCropView.croppedImage()
            ]
            .compactMap { $0 }
            .map { ImagePickerData.Image(image: $0, imageURL: nil) }
        let source = ImagePickerData(
            images: images,
            videos: [])
        self.delegate?.imageCropController(source)
    }
}
