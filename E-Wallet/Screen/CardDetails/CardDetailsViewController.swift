//
//  CardDetailsViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 16/04/2023.
//

import RIBs
import RxSwift
import UIKit
import CreditCardForm

private struct Const {
    static let contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    static let cellHeight = 40.0
    static let cellSpacing = 12.0
}

protocol CardDetailsPresentableListener: AnyObject {
    func backButtonDidTap()
    func removeCard()
    func reloadData()
}

final class CardDetailsViewController: UIViewController, CardDetailsViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var creditCardForm: CreditCardFormView!

    // MARK: - Variables
    weak var listener: CardDetailsPresentableListener?
    private var viewModel: CardDetailsViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    private func config() {
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.registerCell(type: TransactionLimitCell.self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateCardInfor()
    }

    // MARK: - Actions
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.listener?.backButtonDidTap()
    }

    @IBAction func removeCardButtonDidTap(_ sender: Any) {
        ConfirmDialog.shared.delegate = self
        ConfirmDialog.show(message: "Are you sure to remove this card from your payment?")
    }

    // MARK: - Helpers
    func updateCardInfor() {
        if self.viewModel != nil {
            self.creditCardForm.paymentCardTextFieldDidChange(cardNumber: viewModel.cardNumber(),
                                                              expirationYear: viewModel.expirationYear(),
                                                              expirationMonth: viewModel.expirationMonth(),
                                                              cvc: viewModel.cvc())
        }
    }
}

// MARK: - CardDetailsPresentable
extension CardDetailsViewController: CardDetailsPresentable {
    func bind(viewModel: CardDetailsViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.updateCardInfor()
    }

    func bindRemoveCardResult(isSuccess: Bool, message: String) {
        let notificationDialogView = NotificationDialogView.loadView()
        notificationDialogView.delegate = self
        notificationDialogView.show(in: self.view,
                                    title: isSuccess ? "Successfully" : "Failed to remove this card",
                                    message: message)
    }
}

// MARK: - ConfirmDialogDelegate
extension CardDetailsViewController: ConfirmDialogDelegate {
    func confirmDialogDidTapConfirm(_ confirmDialog: ConfirmDialog) {
        self.listener?.removeCard()
    }
}

// MARK: - NotificationDialogViewDelegate
extension CardDetailsViewController: NotificationDialogViewDelegate {
    func notificationDialogViewDidTapOk(_ notificationDialogView: NotificationDialogView) {
        self.listener?.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CardDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfKeys()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: TransactionLimitCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(itemViewModel: self.viewModel.item(at: indexPath.row))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CardDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }
}
