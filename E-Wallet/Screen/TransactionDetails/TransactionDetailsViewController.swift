//
//  TransactionDetailsViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 27/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol TransactionDetailsPresentableListener: AnyObject {
    func copyTransactionId(_ id: String)
    func didTapBackButton()
}

final class TransactionDetailsViewController: UIViewController, TransactionDetailsViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var statusContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var transactionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Variables
    weak var listener: TransactionDetailsPresentableListener?
    private var viewModel: TransactionDetailsViewModel!

    // MARK: - Actions
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.listener?.didTapBackButton()
    }

    @IBAction func copyButtonDidTap(_ sender: Any) {
        self.listener?.copyTransactionId(self.transactionLabel.text ?? "")
    }

    @IBAction func contactSupportButtonDidTap(_ sender: Any) {
    }
}

// MARK: - TransactionDetailsPresentable
extension TransactionDetailsViewController: TransactionDetailsPresentable {
    func bind(viewModel: TransactionDetailsViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.imageView.image = viewModel.image()
        self.amountLabel.text = viewModel.amount()
        self.statusLabel.text = viewModel.status()
        if viewModel.transaction.status == .completed {
            self.statusContainerView.backgroundColor = UIColor(rgb: 0x1AB65C).withAlphaComponent(0.2)
            self.statusLabel.textColor = UIColor(rgb: 0x1AB65C)
        } else {
            self.statusContainerView.backgroundColor = .red.withAlphaComponent(0.2)
            self.statusLabel.textColor = .red
        }

        self.descriptionLabel.text = viewModel.description()
        self.titleLabel.text = viewModel.title()
        self.transactionLabel.text = viewModel.transationId()
        viewModel.receiverInfor { phoneNumber, name in
            self.phoneNumberLabel.text = phoneNumber
            self.nameLabel.text = name
        }
    }

    func bindCopyResult(isSuccess: Bool) {
        self.showToast(message: isSuccess ? "Transaction code was copied to your clipboard" : "Something went wrong. Try again!", font: Outfit.regularFont(size: 16.0))
    }
}
