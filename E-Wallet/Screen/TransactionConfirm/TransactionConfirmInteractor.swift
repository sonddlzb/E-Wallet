//
//  TransactionConfirmInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs
import RxSwift

protocol TransactionConfirmRouting: ViewableRouting {
    func showSelectCard(selectedCard: Card?)
    func dismissSelectCard()
    func reloadData()
    func presentPassword()
    func dismissPassword()
    func bindAuthenticationResultToEnterPassword(isSuccess: Bool)
    func routeToReceipt(transaction: Transaction)
    func dismissReceipt(animated: Bool)
}

protocol TransactionConfirmPresentable: Presentable {
    var listener: TransactionConfirmPresentableListener? { get set }

    func bind(cardViewModel: CardViewModel, balance: Double)
    func bindCardSelectedResult(at indexPath: IndexPath)
    func bind(viewModel: TransactionConfirmViewModel)
    func bindPaymentResult(isSuccess: Bool, message: String)
}

protocol TransactionConfirmListener: AnyObject {
    func transactionConfirmWantToDismiss()
    func selectCardWantToRouteToAddNewCard()
    func receiptWantToRouteToHome()
}

final class TransactionConfirmInteractor: PresentableInteractor<TransactionConfirmPresentable> {

    weak var router: TransactionConfirmRouting?
    weak var listener: TransactionConfirmListener?
    var cardViewModel = CardViewModel.makeEmpty()
    private var balance = 0.0
    var viewModel = TransactionConfirmViewModel.makeEmpty()

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
}

// MARK: - TransactionConfirmPresentableListener
extension TransactionConfirmInteractor: TransactionConfirmPresentableListener {
    func didTapBackButton() {
        self.listener?.transactionConfirmWantToDismiss()
    }

    func showSelectCard(selectedCard: Card?) {
        self.router?.showSelectCard(selectedCard: selectedCard)
    }

    func showPasswordAuthentication() {
        self.router?.presentPassword()
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
