//
//  QRViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 12/05/2023.
//

import RIBs
import RxSwift
import UIKit

protocol QRPresentableListener: AnyObject {
    func selectScanQR()
    func selectMyQR()
    func didTapBackButton()
}

final class QRViewController: UIViewController, QRPresentable {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var scanQRBackgroundView: UIView!
    @IBOutlet private weak var myQRBackgroundView: UIView!

    @IBOutlet private weak var myQRButton: TapableView!
    @IBOutlet private weak var scanQRButton: TapableView!
    // MARK: - Variables
    weak var listener: QRPresentableListener?
    private var currentViewController: ViewControllable?
    var isInScanQRMode = true {
        didSet {
            self.scanQRBackgroundView.isHidden = !isInScanQRMode
            self.myQRBackgroundView.isHidden = isInScanQRMode
            self.scanQRButton.borderWidth = isInScanQRMode ? 1 : 0
            self.myQRButton.borderWidth = isInScanQRMode ? 0 : 1
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.selectScanQR()
    }

    // MARK: - Actions
    @IBAction func didTapMyQRButton(_ sender: Any) {
        guard self.isInScanQRMode else {
            return
        }

        self.isInScanQRMode = false
        self.listener?.selectMyQR()
    }

    @IBAction func didTapScanQRButton(_ sender: Any) {
        guard !self.isInScanQRMode else {
            return
        }

        self.isInScanQRMode = true
        self.listener?.selectScanQR()
    }

    @IBAction func didTapbackButton(_ sender: Any) {
        self.listener?.didTapBackButton()
    }
}

// MARK: - QRViewControllable
extension QRViewController: QRViewControllable {
    func embedViewController(_ viewController: ViewControllable) {
        self.loadViewIfNeeded()

        self.currentViewController?.uiviewController.view.removeFromSuperview()
        self.currentViewController?.uiviewController.removeFromParent()

        self.containerView.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.fitSuperviewConstraint()

        self.addChild(viewController.uiviewController)
        self.currentViewController = viewController
    }
}

