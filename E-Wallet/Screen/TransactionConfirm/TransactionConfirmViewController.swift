//
//  TransactionConfirmViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    static let cellSpacing = 4.0
    static let cellHeight = 50.0
    static let footerHeight = 150.0
}

protocol TransactionConfirmPresentableListener: AnyObject {
    func didTapBackButton()
    func showSelectCard(selectedCard: Card?)
    func showPasswordAuthentication()
}

final class TransactionConfirmViewController: UIViewController, TransactionConfirmViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var confirmButton: TapableView!
    @IBOutlet private weak var confirmLabel: UILabel!
    @IBOutlet private weak var paymentMethodView: PaymentMethodView!

    // MARK: - Variables
    weak var listener: TransactionConfirmPresentableListener?
    private var cardViewModel = CardViewModel.makeEmpty()
    private var selectedCard: Card?
    private var viewModel = TransactionConfirmViewModel.makeEmpty()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.paymentMethodView.delegate = self

        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCell(type: ConfirmDataCell.self)
        collectionView.register(UINib(nibName: "TransactionFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "TransactionFooterView")
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBackButton()
    }

    @IBAction func didTapConfirmButton(_ sender: Any) {
        self.listener?.showPasswordAuthentication()
    }

    // MARK: - Helpers
    func checkPurchasble() {
        var isPurchasable = true
        if self.selectedCard == nil {
            isPurchasable = self.viewModel.amount() <= self.paymentMethodView.balance
        }

        self.confirmLabel.backgroundColor = isPurchasable ? .crayola : .lightGray
        self.confirmButton.isUserInteractionEnabled = isPurchasable
    }
}

// MARK: - TransactionConfirmPresentable
extension TransactionConfirmViewController: TransactionConfirmPresentable {
    func bind(cardViewModel: CardViewModel, balance: Double) {
        self.cardViewModel = cardViewModel
        self.paymentMethodView.selectedCard = self.selectedCard
        self.paymentMethodView.bind(viewModel: cardViewModel, balance: balance)
        self.checkPurchasble()
    }

    func bindCardSelectedResult(at indexPath: IndexPath) {
        self.loadViewIfNeeded()
        if indexPath.row == 0 {
            self.selectedCard = nil
        } else {
            self.selectedCard = self.cardViewModel.listCards[indexPath.row-1]
        }

        self.paymentMethodView.selectCard(at: indexPath)
        self.checkPurchasble()
    }

    func bind(viewModel: TransactionConfirmViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.checkPurchasble()
        self.collectionView.reloadData()
    }

    func bindPaymentResult(isSuccess: Bool, message: String) {
        if !isSuccess {
            FailedDialog.show(title: "Payment failed!", message: message)
        }
    }
}

// MARK: - PaymentMethodViewDelegate
extension TransactionConfirmViewController: PaymentMethodViewDelegate {
    func paymentMethodView(_ paymentMethodView: PaymentMethodView, didSelect card: Card?) {
        self.selectedCard = card
        self.checkPurchasble()
    }

    func paymentMethodViewWantToShowAllCard(_ paymentMethodView: PaymentMethodView) {
        self.listener?.showSelectCard(selectedCard: self.selectedCard)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TransactionConfirmViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: ConfirmDataCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(itemViewModel: self.viewModel.item(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TransactionFooterView", for: indexPath) as? TransactionFooterView else {
            return UICollectionReusableView()
        }

        footerView.bind(amount: self.viewModel.amount(), discount: 2.0)
        return footerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TransactionConfirmViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.footerHeight
        return CGSize(width: width, height: height)
    }
}
