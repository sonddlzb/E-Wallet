//
//  TransactionConfirmInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol TransactionConfirmRouting: ViewableRouting {
    func showSelectCard(selectedCard: Card?)
    func dismissSelectCard()
    func reloadData()
    func presentPassword()
    func dismissPassword()
    func bindAuthenticationResultToEnterPassword(isSuccess: Bool)
    func routeToReceipt(transaction: Transaction)
    func dismissReceipt(animated: Bool)
    func routeToGiftApply(paymentType: PaymentType, amount: Double)
    func dismissGiftApply()
}

protocol TransactionConfirmPresentable: Presentable {
    var listener: TransactionConfirmPresentableListener? { get set }

    func bind(cardViewModel: CardViewModel, balance: Double)
    func bindCardSelectedResult(at indexPath: IndexPath)
    func bind(viewModel: TransactionConfirmViewModel)
    func bind(voucher: Voucher)
    func bindPaymentResult(isSuccess: Bool, message: String)
}

protocol TransactionConfirmListener: AnyObject {
    func transactionConfirmWantToDismiss()
    func selectCardWantToRouteToAddNewCard()
    func receiptWantToRouteToHome()
    func receiptWantToSeeDetails(transaction: Transaction)
    func transactionConfirmWantToEndLoginSession()
}

final class TransactionConfirmInteractor: PresentableInteractor<TransactionConfirmPresentable> {

    weak var router: TransactionConfirmRouting?
    weak var listener: TransactionConfirmListener?
    var cardViewModel = CardViewModel.makeEmpty()
    private var balance = 0.0
    var viewModel = TransactionConfirmViewModel.makeEmpty()
    var voucher: Voucher?

    init(presenter: TransactionConfirmPresentable, confirmData: [String: String]) {
        self.viewModel = TransactionConfirmViewModel(confirmData: confirmData)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchAccounts()
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchAccounts() {
        CardDatabase.shared.getListOfCards { [weak self] listCards in
            guard let self = self else {
                return
            }

            self.cardViewModel = CardViewModel(listCards: listCards)
            AccountDatabase.shared.getAccountInfor { [weak self] accountEntity in
                guard let self = self else {
                    return
                }

                self.balance = accountEntity.balance
                DispatchQueue.main.async {
                    self.presenter.bind(cardViewModel: self.cardViewModel, balance: self.balance)
                }
            }
        }
    }

    func transferMoney() {
        AccountDatabase.shared.transfer(selectedCard: self.viewModel.selectedCard, amount: self.viewModel.amount(), receiverPhoneNumber: self.viewModel.phoneNumber(), completion: { [weak self] error, transaction in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if let error = error {
                    print("transfer failed! \(error.localizedDescription)")
                    self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                } else {
                    if let voucherId = self?.voucher?.id {
                        VoucherDatabase.shared.removeVoucher(voucherId: voucherId)
                    }

                    print("transfer successfully")
                    self?.presenter.bindPaymentResult(isSuccess: true, message: "Your money has been transfered successfully")
                    if let transaction = transaction {
                        self?.router?.routeToReceipt(transaction: transaction)
                    }
                }
            }
        })
    }

    func topUpMoney() {
        CardDatabase.shared.getCardById(self.viewModel.cardId()) { card in
            guard let card = card else {
                return
            }

            STPPaymentHelper.shared.handlePayment(card: card, price: self.viewModel.amount(), paymentType: .topUp, completion: {[weak self] error in
                if let error = error {
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                    }
                } else {
                    AccountDatabase.shared.topUp(amount: self?.viewModel.amount() ?? 0.0) { error, transaction in
                        SVProgressHUD.dismiss()
                        if let error = error {
                            self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                        } else {
                            DispatchQueue.main.async {
                                if let voucherId = self?.voucher?.id {
                                    VoucherDatabase.shared.removeVoucher(voucherId: voucherId)
                                }

                                self?.presenter.bindPaymentResult(isSuccess: true, message: "Your top-up payment was handled successfully")
                                if let transaction = transaction {
                                    self?.router?.routeToReceipt(transaction: transaction)
                                }
                            }
                        }
                    }
                }
            })
        }
    }

    func withdrawMoney() {
        CardDatabase.shared.getCardById(self.viewModel.cardId()) { card in
            guard let card = card else {
                return
            }

            STPPaymentHelper.shared.handlePayment(card: card, price: self.viewModel.amount(), paymentType: .withdraw, completion: {[weak self] error in
                if let error = error {
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                    }
                } else {
                    AccountDatabase.shared.withdraw(amount: self?.viewModel.amount() ?? 0.0) { error, transaction in
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            if let error = error {
                                self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                            } else {
                                if let voucherId = self?.voucher?.id {
                                    VoucherDatabase.shared.removeVoucher(voucherId: voucherId)
                                }

                                self?.presenter.bindPaymentResult(isSuccess: true, message: "Your withdraw payment was handled successfully")
                                if let transaction = transaction {
                                    self?.router?.routeToReceipt(transaction: transaction)
                                }
                            }
                        }
                    }
                }
            })
        }
    }

    func handleBillPayment() {
        if let paymentType = self.viewModel.paymentType() {
            AccountDatabase.shared.handlePayment(selectedCard: self.viewModel.selectedCard, billId: self.viewModel.billId(), paymentType: paymentType, amount: self.viewModel.amount() - self.viewModel.discount) { [weak self] error, transaction in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    if let error = error {
                        self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                    } else {
                        // not remove voucher for test purpose
//                        if let voucherId = self?.voucher?.id {
//                            VoucherDatabase.shared.removeVoucher(voucherId: voucherId)
//                        }

                        self?.presenter.bindPaymentResult(isSuccess: true, message: "Your bill payment was handled successfully")
                        if let transaction = transaction {
                            self?.router?.routeToReceipt(transaction: transaction)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - TransactionConfirmPresentableListener
extension TransactionConfirmInteractor: TransactionConfirmPresentableListener {
    func didTapBackButton() {
        self.listener?.transactionConfirmWantToDismiss()
    }

    func showSelectCard(selectedCard: Card?) {
        self.router?.showSelectCard(selectedCard: selectedCard)
    }

    func showPasswordAuthentication(selectedCard: Card?) {
        self.viewModel.selectedCard = selectedCard
        self.router?.presentPassword()
    }

    func showDiscount() {
        if let paymentType = self.viewModel.paymentType() {
            self.router?.routeToGiftApply(paymentType: paymentType, amount: self.viewModel.amount())
        }
    }

    func removeDiscount() {
        self.viewModel.discount = 0.0
        self.presenter.bind(viewModel: self.viewModel)
    }
}

// MARK: - TransactionConfirmInteractable
extension TransactionConfirmInteractor: TransactionConfirmInteractable {
    func reloadData() {
        CardDatabase.shared.getListOfCards { [weak self] listCards in
            guard let self = self else {
                return
            }

            self.cardViewModel.listCards = listCards
            self.presenter.bind(cardViewModel: self.cardViewModel, balance: self.balance)
            self.presenter.bindCardSelectedResult(at: IndexPath(row: 0, section: 0))
        }
    }
}
