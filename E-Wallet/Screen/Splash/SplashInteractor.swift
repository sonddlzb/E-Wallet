//
//  SplashInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import RIBs
import RxSwift

protocol SplashRouting: ViewableRouting {
}

protocol SplashPresentable: Presentable {
    var listener: SplashPresentableListener? { get set }
}

protocol SplashListener: AnyObject {
    func splashWantToRouteToSignIn()
}

final class SplashInteractor: PresentableInteractor<SplashPresentable>, SplashInteractable, SplashPresentableListener {

    weak var router: SplashRouting?
    weak var listener: SplashListener?

    override init(presenter: SplashPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            self.listener?.splashWantToRouteToSignIn()
        })
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
