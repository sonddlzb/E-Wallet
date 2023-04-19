//
//  TransactionConfirmViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol TransactionConfirmPresentableListener: AnyObject {
    func didTapBackButton()
    func showSelectCard(selectedCard: Card?)
}

final class TransactionConfirmViewController: UIViewController, TransactionConfirmViewControllable {
    // MARK: - Outlets
    @IBOutlet weak var paymentMethodView: PaymentMethodView!

    // MARK: - Variables
    weak var listener: TransactionConfirmPresentableListener?
    private var cardViewModel = CardViewModel.makeEmpty()
    private var selectedCard: Card?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.paymentMethodView.delegate = self
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBackButton()
    }
}

// MARK: - TransactionConfirmPresentable
extension TransactionConfirmViewController: TransactionConfirmPresentable {
    func bind(cardViewModel: CardViewModel, balance: Double) {
        self.cardViewModel = cardViewModel
        self.paymentMethodView.selectedCard = self.selectedCard
        self.paymentMethodView.bind(viewModel: cardViewModel, balance: balance)
    }

    func bindCardSelectedResult(at indexPath: IndexPath) {
        self.loadViewIfNeeded()
        if indexPath.row == 0 {
            self.selectedCard = nil
        } else {
            self.selectedCard = self.cardViewModel.listCards[indexPath.row-1]
        }

        self.paymentMethodView.selectCard(at: indexPath)
    }
}

// MARK: - PaymentMethodViewDelegate
extension TransactionConfirmViewController: PaymentMethodViewDelegate {
    func paymentMethodView(_ paymentMethodView: PaymentMethodView, didSelect card: Card?) {
        self.selectedCard = card
    }

    func paymentMethodViewWantToShowAllCard(_ paymentMethodView: PaymentMethodView) {
        self.listener?.showSelectCard(selectedCard: self.selectedCard)
    }
}
