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
}

protocol AccountPresentable: Presentable {
    var listener: AccountPresentableListener? { get set }
}

protocol AccountListener: AnyObject {
}

final class AccountInteractor: PresentableInteractor<AccountPresentable>, AccountInteractable {

    weak var router: AccountRouting?
    weak var listener: AccountListener?

    override init(presenter: AccountPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - AccountPresentableListener
extension AccountInteractor: AccountPresentableListener {
    func routeToAddCard() {
        self.router?.routeToAddCard()
    }
}
