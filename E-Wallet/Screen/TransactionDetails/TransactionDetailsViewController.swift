//
//  TransactionDetailsViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 27/04/2023.
//

import RIBs
import RxSwift
import UIKit
import MessageUI

protocol TransactionDetailsPresentableListener: AnyObject {
    func copyTransactionId(_ id: String)
    func didTapBackButton()
}

final class TransactionDetailsViewController: UIViewController, TransactionDetailsViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var transactionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var supplierLabel: UILabel!
    @IBOutlet private weak var customerIDLabel: UILabel!
    @IBOutlet private weak var customerNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var billTypeLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    @IBOutlet private weak var billStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var historyStackViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var billStackView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var phoneNumberContainer: UIView!
    @IBOutlet private weak var receiverContainer: UIView!
    @IBOutlet private weak var statusContainerView: UIView!

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
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["ewalletfeedbackcenter@gmail.com"])
            mailComposer.setSubject("Transaction \(self.viewModel.transaction.id): \(self.viewModel.description())")
            present(mailComposer, animated: true, completion: nil)
        } else {
            FailedDialog.show(title: "Mail is not available", message: "Your device is not supported to send an email")
        }
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
        self.timeLabel.text = viewModel.time()
        self.messageLabel.text = viewModel.message()

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

        var billTypes: [PaymentType] = [.electricity, .internet, .water, .televison]
        if billTypes.contains(self.viewModel.transaction.type) {
            self.billStackViewHeightConstraint.constant = 200.0
            self.billStackView.isHidden = false
            self.historyStackViewHeightConstraint.constant = 160.0
            self.phoneNumberContainer.isHidden = true
            self.receiverContainer.isHidden = true
        } else {
            self.billStackViewHeightConstraint.constant = 0.0
            self.billStackView.isHidden = true
            self.historyStackViewHeightConstraint.constant = 240.0
            self.phoneNumberContainer.isHidden = false
            self.receiverContainer.isHidden = false
        }
    }

    func bindCopyResult(isSuccess: Bool) {
        self.view.makeToast(isSuccess ? "Transaction code was copied to your clipboard" : "Something went wrong. Try again!")
    }

    func bind(viewModel: BillDetailsViewModel) {
        self.supplierLabel.text = viewModel.supplier()
        self.customerIDLabel.text = viewModel.customerId()
        self.customerNameLabel.text = viewModel.customerName()
        self.addressLabel.text = viewModel.address()
        self.billTypeLabel.text = viewModel.billType()
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension TransactionDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if let error = error {
            FailedDialog.show(title: "Sent mail failed", message: error.localizedDescription)
        } else {
            self.view.makeToast("Your mail was sent successfully!")
        }
    }
}
