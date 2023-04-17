//
//  AccountInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs
import RxSwift

protocol AccountRouting: ViewableRouting {
    func routeToAddCard()
    func dismissAddCard()
    func routeToCardDetails(_ card: Card)
    func dismissCardDetails()
}

protocol AccountPresentable: Presentable {
    var listener: AccountPresentableListener? { get set }

    func bind(viewModel: AccountViewModel)
}

protocol AccountListener: AnyObject {
}

final class AccountInteractor: PresentableInteractor<AccountPresentable>, AccountInteractable {

    weak var router: AccountRouting?
    weak var listener: AccountListener?
    private var viewModel = AccountViewModel.makeEmpty()

    override init(presenter: AccountPresentable) {
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
            self.viewModel = AccountViewModel(listCards: listCards)
            self.presenter.bind(viewModel: self.viewModel)
        }
    }
}

// MARK: - AccountPresentableListener
extension AccountInteractor: AccountPresentableListener {
    func routeToAddCard() {
        self.router?.routeToAddCard()
    }

    func didSelectCard(_ card: Card) {
        self.router?.routeToCardDetails(card)
    }
}
