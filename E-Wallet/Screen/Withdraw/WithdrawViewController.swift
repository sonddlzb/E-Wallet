//
//  WithdrawViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs
import RxSwift
import UIKit
import Stripe

private struct Const {
    static let contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    static let cellSpacing = 12.0
    static let cellHeight = 60.0
}

protocol WithdrawPresentableListener: AnyObject {
    func didTapBackButton()
    func routeToAddCard()
    func didTapWithdrawButton(card: Card, amount: Double)
}

final class WithdrawViewController: UIViewController, WithdrawViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var moneyTextField: UITextField!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var withdrawButton: TapableView!
    @IBOutlet private weak var withdrawLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!

    // MARK: - Variables
    weak var listener: WithdrawPresentableListener?
    private var viewModel = CardViewModel.makeEmpty()
    private var selectedCard: Card?
    private var homeViewModel: HomeViewModel?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    private func config() {
        self.moneyTextField.keyboardType = .decimalPad
        self.moneyTextField.delegate = self

        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.registerCell(type: CardCell.self)
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBackButton()
    }

    @IBAction func didTapWithDrawButton(_ sender: Any) {
        if let amount = self.moneyTextField.text?.convertMoneyToNumber() as? Double, let selectedCard = self.selectedCard {
            STPPaymentHelper.shared.viewController = self
            self.listener?.didTapWithdrawButton(card: selectedCard, amount: amount)
        }
    }
}

// MARK: - UITextFieldDelegate
extension WithdrawViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the text after adding the replacement string.
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""

        // Remove all non-digit characters from the updated text.
        let filteredText = updatedText.filter("0123456789".contains)
        if filteredText.isEmpty {
            textField.textColor = .lightGray
            self.withdrawButton.backgroundColor = .lightGray
            self.withdrawButton.isUserInteractionEnabled = false
        } else {
            textField.textColor = .black
            self.withdrawButton.backgroundColor = .crayola
            self.withdrawButton.isUserInteractionEnabled = true
        }

        if let money = filteredText.toDouble() {
            let balance = self.homeViewModel?.balance() ?? 0.0
            if money > balance {
                self.withdrawButton.backgroundColor = .lightGray
                self.withdrawButton.isUserInteractionEnabled = false
            } else {
                self.withdrawButton.backgroundColor = .crayola
                self.withdrawButton.isUserInteractionEnabled = true
            }
        }

        textField.text = filteredText.formatMoney()
        return false
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension WithdrawViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfAccounts() + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: CardCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        if indexPath.row == self.viewModel.numberOfAccounts() {
            cell.setUpAddCell()
        } else {
            if self.selectedCard == nil {
                self.selectedCard = self.viewModel.item(at: 0).card
            }

            let itemViewModel = self.viewModel.item(at: indexPath.row)
            cell.bind(itemViewModel: itemViewModel, isSelected: itemViewModel.card.id == self.selectedCard!.id)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != self.viewModel.numberOfAccounts() {
            guard let previousSelectedIndex = self.viewModel.listCards.firstIndex(where: { card in
                self.selectedCard?.id == card.id
            }) else {
                return
            }

            self.selectedCard = self.viewModel.item(at: indexPath.row).card
            self.collectionView.reloadItems(at: [IndexPath(row: previousSelectedIndex, section: 0), indexPath])
        } else {
            self.listener?.routeToAddCard()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WithdrawViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }
}

// MARK: - WithdrawPresentable
extension WithdrawViewController: WithdrawPresentable {
    func bind(viewModel: CardViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.collectionView.reloadData()
    }

    func bindWithdrawResult(isSuccess: Bool, message: String) {
        if isSuccess {
            let notificationDialogView = NotificationDialogView.loadView()
            notificationDialogView.delegate = self
            notificationDialogView.show(in: self.view, title: "Successfully", message: message)
        } else {
            FailedDialog.show(title: "Failed to top up", message: message)
        }
    }

    func bind(homeViewModel: HomeViewModel) {
        self.loadViewIfNeeded()
        self.homeViewModel = homeViewModel
        self.balanceLabel.text = "$" + String(homeViewModel.balance()).formatMoney()
    }
}

// MARK: - NotificationDialogViewDelegate
extension WithdrawViewController: NotificationDialogViewDelegate {
    func notificationDialogViewDidTapOk(_ notificationDialogView: NotificationDialogView) {
        self.listener?.didTapBackButton()
    }
}

// MARK: - STPAuthenticationContext
extension WithdrawViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

