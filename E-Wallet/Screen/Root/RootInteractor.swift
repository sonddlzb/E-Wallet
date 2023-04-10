//
//  RootInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 30/03/2023.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    func routeToSignIn()
    func dismissSignIn()
    func routeToSplash()
    func dismissSplash()
    func routeToHome()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject {
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?

    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
//        self.router?.routeToSplash()
        self.routeToHome()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
