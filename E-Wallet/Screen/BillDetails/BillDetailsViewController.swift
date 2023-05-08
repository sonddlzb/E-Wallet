//
//  BillDetailsViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 08/05/2023.
//

import RIBs
import RxSwift
import UIKit

protocol BillDetailsPresentableListener: AnyObject {
    func didTapCheckout()
}

final class BillDetailsViewController: UIViewController, BillDetailsViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var supplierLabel: UILabel!
    @IBOutlet private weak var customerIDLabel: UILabel!
    @IBOutlet private weak var customerNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var billTypeLabel: UILabel!
    @IBOutlet private weak var periodLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!

    // MARK: - Variables
    weak var listener: BillDetailsPresentableListener?
    var viewModel: BillDetailsViewModel!

    // MARK: - Actions
    @IBAction func didTapCheckoutButton(_ sender: Any) {
        self.listener?.didTapCheckout()
    }
}

// MARK: - BillDetailsPresentable
extension BillDetailsViewController: BillDetailsPresentable {
    func bind(viewModel: BillDetailsViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.supplierLabel.text = viewModel.supplier()
        self.customerIDLabel.text = viewModel.customerId()
        self.customerNameLabel.text = viewModel.customerName()
        self.addressLabel.text = viewModel.address()
        self.billTypeLabel.text = viewModel.billType()
        self.periodLabel.text = viewModel.period()
        self.amountLabel.text = viewModel.amount()
    }
}
