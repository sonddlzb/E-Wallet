//
//  TransactionConfirmViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs
import RxSwift
import UIKit
import Stripe

private struct Const {
    static let contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    static let cellSpacing = 4.0
    static let cellHeight = 50.0
    static let footerHeight = 150.0
}

protocol TransactionConfirmPresentableListener: AnyObject {
    func didTapBackButton()
    func showSelectCard(selectedCard: Card?)
    func showPasswordAuthentication(selectedCard: Card?)
    func showDiscount()
    func removeDiscount()
}

final class TransactionConfirmViewController: UIViewController, TransactionConfirmViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var confirmButton: TapableView!
    @IBOutlet private weak var confirmLabel: UILabel!
    @IBOutlet private weak var paymentMethodView: PaymentMethodView!

    @IBOutlet private weak var contentViewTopConstraint: NSLayoutConstraint!

    // MARK: - Variables
    weak var listener: TransactionConfirmPresentableListener?
    private var cardViewModel = CardViewModel.makeEmpty()
    private var selectedCard: Card?
    private var viewModel = TransactionConfirmViewModel.makeEmpty()
    private var isShowPaymentMethodView = true
    private var voucher: Voucher?

    // MARK: - Lifecycle
    init(isShowPaymentMethodView: Bool) {
        self.isShowPaymentMethodView = isShowPaymentMethodView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        self.contentViewTopConstraint.constant = self.isShowPaymentMethodView ? 140.0 : 20.0
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBackButton()
    }

    @IBAction func didTapConfirmButton(_ sender: Any) {
        STPPaymentHelper.shared.viewController = self
        self.listener?.showPasswordAuthentication(selectedCard: self.selectedCard)
    }

    // MARK: - Helpers
    func checkPurchasble() {
        var isPurchasable = true
        if self.selectedCard == nil && isShowPaymentMethodView {
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

    func bind(voucher: Voucher) {
        self.voucher = voucher
        self.collectionView.reloadData()
    }

    func pauseScreen() {
        self.view.isUserInteractionEnabled = false
    }

    func continueScreen() {
        self.view.isUserInteractionEnabled = true
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

        footerView.bind(amount: self.viewModel.amount(), discount: self.viewModel.discount)
        if let voucher = self.voucher {
            footerView.bind(voucher: voucher)
        }

        footerView.delegate = self
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

// MARK: - STPAuthenticationContext
extension TransactionConfirmViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

// MARK: - TransactionFooterViewDelagate
extension TransactionConfirmViewController: TransactionFooterViewDelagate {
    func transactionFooterViewDidSelectDiscount(_ transactionFooterView: TransactionFooterView) {
        self.listener?.showDiscount()
    }

    func transactionFooterViewDidSelectCancel(_ transactionFooterView: TransactionFooterView) {
        self.listener?.removeDiscount()
    }
}
