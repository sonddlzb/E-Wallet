//
//  DashboardInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs
import RxSwift

protocol DashboardRouting: ViewableRouting {
}

protocol DashboardPresentable: Presentable {
    var listener: DashboardPresentableListener? { get set }
}

protocol DashboardListener: AnyObject {
}

final class DashboardInteractor: PresentableInteractor<DashboardPresentable>, DashboardInteractable, DashboardPresentableListener {

    weak var router: DashboardRouting?
    weak var listener: DashboardListener?

    override init(presenter: DashboardPresentable) {
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
