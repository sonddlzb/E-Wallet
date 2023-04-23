//
//  ReceiptViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 21/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol ReceiptPresentableListener: AnyObject {
    func didTapHomeButton()
    func didTapSeeDetailsButton()
}

final class ReceiptViewController: UIViewController, ReceiptViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var amountNameLabel: UILabel!
    @IBOutlet private weak var amountValueLabel: UILabel!
    @IBOutlet private weak var dateTimeLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!

    // MARK: - Variables
    weak var listener: ReceiptPresentableListener?
    private var viewModel: ReceiptViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    @IBAction func homeButtonDidTap(_ sender: Any) {
        self.listener?.didTapHomeButton()
    }
    @IBAction func shareButtonDidTap(_ sender: Any) {
        guard let screenshot = self.view.image() else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }

    @IBAction func seeDetailsButtonDidTap(_ sender: Any) {
        self.listener?.didTapSeeDetailsButton()
    }
}

// MARK: - ReceiptPresentable
extension ReceiptViewController: ReceiptPresentable {
    func bind(viewModel: ReceiptViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.titleLabel.text = self.viewModel.title()
        self.messageLabel.text = self.viewModel.message()
        self.amountNameLabel.text = self.viewModel.amountName()
        self.amountValueLabel.text = self.viewModel.amount()
        self.dateTimeLabel.text = self.viewModel.time()
        self.idLabel.text = self.viewModel.refId()
    }
}
