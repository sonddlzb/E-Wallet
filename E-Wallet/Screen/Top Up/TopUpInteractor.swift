//
//  TopUpInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import RIBs
import RxSwift
import Stripe
import SVProgressHUD

protocol TopUpRouting: ViewableRouting {
    func reloadData()
}

protocol TopUpPresentable: Presentable {
    var listener: TopUpPresentableListener? { get set }

    func bind(viewModel: CardViewModel)
    func bindTopUpResult(isSuccess: Bool, message: String)
}

protocol TopUpListener: AnyObject {
    func topUpWantToDismiss()
    func topUpWantToRouteToAddCard()
    func topUpWantToRouteToTransactionConfirm(confirmData: [String: String])
}

final class TopUpInteractor: PresentableInteractor<TopUpPresentable> {

    weak var router: TopUpRouting?
    weak var listener: TopUpListener?
    private var viewModel = CardViewModel.makeEmpty()

    override init(presenter: TopUpPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchAccounts()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchAccounts() {
        CardDatabase.shared.getListOfCards { listCards in
            self.viewModel = CardViewModel(listCards: listCards)
            self.presenter.bind(viewModel: self.viewModel)
        }
    }
}

// MARK: - TopUpPresentableListener
extension TopUpInteractor: TopUpPresentableListener {
    func didTapBackButton() {
        self.listener?.topUpWantToDismiss()
    }

    func routeToAddCard() {
        self.listener?.topUpWantToRouteToAddCard()
    }

    func didTapTopUpButton(card: Card, amount: Double) {
        let confirmData: [String: String] = ["Payment Type": "Top Up",
                                             "Payment Methods": card.type.rawValue.capitalized,
                                             "Amount": "$" + String(amount), "cardId": card.id]
        self.listener?.topUpWantToRouteToTransactionConfirm(confirmData: confirmData)
    }
}

// MARK: - TopUpInteractable
extension TopUpInteractor: TopUpInteractable {
    func reloadData() {
        self.fetchAccounts()
    }
}
