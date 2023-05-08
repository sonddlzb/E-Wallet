//
//  VoucherDetailsViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import RIBs
import RxSwift
import UIKit

protocol VoucherDetailsPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapUseNow()
}

final class VoucherDetailsViewController: UIViewController, VoucherDetailsViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var iconImageView: UIImageView!

    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var expiredLabel: UILabel!
    @IBOutlet weak var effectedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Variables
    weak var listener: VoucherDetailsPresentableListener?
    var viewModel: VoucherDetailsViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.addBackgroundImageBottomShadow()
    }

    private func addBackgroundImageBottomShadow() {
        let bottomGradientLayer = CAGradientLayer()
        bottomGradientLayer.colors = [UIColor.clear.cgColor, UIColor(rgb: 0xEEF0EF).cgColor]
        bottomGradientLayer.locations = [0.5, 1]
        bottomGradientLayer.frame = self.backgroundImageView.bounds
        self.backgroundImageView.layer.addSublayer(bottomGradientLayer)
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBackButton()
    }
    @IBAction func didTapUseNow(_ sender: Any) {
        self.listener?.didTapUseNow()
    }
}

// MARK: - VoucherDetailsPresentable
extension VoucherDetailsViewController: VoucherDetailsPresentable {
    func bind(viewModel: VoucherDetailsViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.titleLabel.text = viewModel.description()
        self.effectedLabel.text = viewModel.effectedTime()
        self.expiredLabel.text = viewModel.expiredTime()
        self.serviceTypeLabel.text = viewModel.serviceTypeContent()
        self.minValueLabel.text = viewModel.minValueContent()
        self.iconImageView.image = viewModel.image()
    }

    func bindNotReadyToUseResult() {
        NotificationDialogView.loadView().show(in: self.view, title: "Your voucher is not ready!",
                                               message: "From \(self.viewModel.voucher.openTime.formatDate()) you can use this voucher to receiver discount from E-Wallet. Please come back later.",
                                               image: UIImage(named: "ic_waiting"),
                                               color: .crayola)
    }
}
