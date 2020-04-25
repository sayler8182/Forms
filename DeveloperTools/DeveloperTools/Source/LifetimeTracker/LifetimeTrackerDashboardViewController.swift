//
//  LifetimeTrackerDashboardViewController.swift
//  DeveloperTools
//
//  Created by Konrad on 4/25/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: LifetimeTrackerDashboardViewController
class LifetimeTrackerDashboardViewController: UIViewController, LifetimeTrackerViewable {
    private let roundView: UIView = UIView()
    private let leaksCountLabel: UILabel = UILabel()
    private let leaksTitleLabel: UILabel = UILabel()

    private weak var listController: LifetimeTrackerListViewController?
    private var hideOption: LifetimeHideOption = .none
    private var dashboard: LifetimeTrackerDashboard?

    private let size: CGFloat = 70.0
    private var dragOffset: CGSize = CGSize.zero {
        didSet { self.relayout() }
    }
    private var originalOffset = CGSize.zero
    
    private var mainWindow: UIWindow?
    private lazy var window: UIWindow = {
        let window = UIWindow(windowScene: LifetimeTrackerManager.scene)
        window.windowLevel = UIWindow.Level.statusBar
        window.frame = UIScreen.main.bounds
        let controller = UIViewController()
        window.rootViewController = controller
        return window
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRoundView()
        self.setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dragOffset = CGSize(width: UIScreen.main.bounds.size.width - self.size * 0.6, height: self.size)
    }
    
    private func setupRoundView() {
        self.roundView.translatesAutoresizingMaskIntoConstraints = false
        self.roundView.frame = CGRect(x: 0, y: 0, width: self.size, height: self.size)
        self.roundView.backgroundColor = UIColor.tertiarySystemBackground
        self.roundView.layer.cornerRadius = self.roundView.frame.height / 2
        self.roundView.clipsToBounds = false
        self.roundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        self.roundView.layer.shadowOpacity = 0.3
        self.roundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.roundView.layer.shadowRadius = 10
        self.roundView.layer.shadowPath = UIBezierPath(
            roundedRect: self.roundView.bounds,
            cornerRadius: self.roundView.frame.height / 2
        ).cgPath
        self.view.addSubview(self.roundView)
        NSLayoutConstraint.activate([
            self.roundView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.roundView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
        self.leaksCountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.leaksCountLabel.font = UIFont.systemFont(ofSize: 24)
        self.leaksCountLabel.textAlignment = .center
        self.roundView.addSubview(self.leaksCountLabel)
        NSLayoutConstraint.activate([
            self.leaksCountLabel.centerYAnchor.constraint(equalTo: self.roundView.centerYAnchor, constant: -8),
            self.leaksCountLabel.leadingAnchor.constraint(equalTo: self.roundView.leadingAnchor, constant: 8),
            self.leaksCountLabel.trailingAnchor.constraint(equalTo: self.roundView.trailingAnchor, constant: -8)
        ])
        self.leaksTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.leaksTitleLabel.font = UIFont.systemFont(ofSize: 12)
        self.leaksTitleLabel.textAlignment = .center
        self.leaksTitleLabel.text = "Leaks"
        self.leaksTitleLabel.textColor = UIColor.label
        self.roundView.addSubview(self.leaksTitleLabel)
        NSLayoutConstraint.activate([
            self.leaksTitleLabel.topAnchor.constraint(equalTo: self.leaksCountLabel.bottomAnchor),
            self.leaksTitleLabel.leadingAnchor.constraint(equalTo: self.roundView.leadingAnchor, constant: 8),
            self.leaksTitleLabel.trailingAnchor.constraint(equalTo: self.roundView.trailingAnchor, constant: -8)
        ])
    }
    
    func setupActions() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.view.addGestureRecognizer(panGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.view.addGestureRecognizer(longPressGestureRecognizer)
    }

    @objc
    func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.originalOffset = self.dragOffset
        case .changed:
            let translation: CGPoint = recognizer.translation(in: self.view)
            self.dragOffset.height = self.originalOffset.height + translation.y
            self.dragOffset.width = self.originalOffset.width + translation.x
        case .ended,
             .cancelled:
            UIView.animate(
                withDuration: 0.6,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 5,
                options: .curveEaseInOut,
                animations: self.clampDragOffset,
                completion: nil)
        default: break
        }
    }
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        let controller = LifetimeTrackerListViewController(dashboard: self.dashboard)
        controller.show()
        self.listController = controller
    }

    @objc
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        LifetimeTrackerManager.showLifetimeSettings(on: self.window) { (option) in
            self.hideOption = option
            self.mainWindow?.isHidden = option != .none
        }
    }

    func update(with dashboard: LifetimeTrackerDashboard,
                on mainWindow: UIWindow,
                isEnabled: Bool) {
        self.mainWindow = mainWindow
        let oldDashboard: LifetimeTrackerDashboard? = self.dashboard
        self.dashboard = dashboard
        self.leaksCountLabel.text = "\(dashboard.leaksCount)"
        self.leaksCountLabel.textColor = dashboard.leaksCount == 0
            ? UIColor.green
            : UIColor.red
        self.listController?.update(dashboard: dashboard)
        self.relayout()
        
        let isVisible = self.hideOption.isVisible(
            old: oldDashboard,
            new: dashboard)
        mainWindow.isHidden = !isEnabled || !isVisible
        if isVisible {
            self.hideOption = .none
        }
    }
    
    private func relayout() {
        self.view.window?.frame = CGRect(
            x: self.dragOffset.width,
            y: self.dragOffset.height,
            width: self.size,
            height: self.size)
    }
    
    private func clampDragOffset() {
        let maxHiddenWidth = self.view.frame.size.width * 0.4
        if self.dragOffset.width < -maxHiddenWidth {
            self.dragOffset.width = -maxHiddenWidth
        } else if self.dragOffset.width > UIScreen.main.bounds.width - view.frame.size.width + maxHiddenWidth {
            self.dragOffset.width = UIScreen.main.bounds.width - view.frame.size.width + maxHiddenWidth
        }

        let maxHiddenHeight = view.frame.size.height * 0.4
        if self.dragOffset.height < -maxHiddenHeight {
            self.dragOffset.height = -maxHiddenHeight
        } else if self.dragOffset.height > UIScreen.main.bounds.height - view.frame.size.height + maxHiddenHeight {
            self.dragOffset.height = UIScreen.main.bounds.height - view.frame.size.height + maxHiddenHeight
        }
    }
} 

// MARK: UIPopoverPresentationControllerDelegate
extension LifetimeTrackerDashboardViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.permittedArrowDirections = .any
        popoverPresentationController.sourceView = self.roundView
    }
}
