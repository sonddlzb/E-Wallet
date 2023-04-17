//
//  DashboardInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs
import RxSwift

protocol DashboardRouting: ViewableRouting {
    func bind(homeViewModel: HomeViewModel)
}

protocol DashboardPresentable: Presentable {
    var listener: DashboardPresentableListener? { get set }

    func bind(homeViewModel: HomeViewModel)
}

protocol DashboardListener: AnyObject {
    func dashboadWantToRouteToTransfer()
    func dashboadWantToRouteToTopUp()
}

final class DashboardInteractor: PresentableInteractor<DashboardPresentable> {

    weak var router: DashboardRouting?
    weak var listener: DashboardListener?
    private var homeViewModel: HomeViewModel!

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

// MARK: - DashboardInteractable
extension DashboardInteractor: DashboardInteractable {
    func bind(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.presenter.bind(homeViewModel: self.homeViewModel)
    }
}

// MARK: - DashboardPresentableListener
extension DashboardInteractor: DashboardPresentableListener {
    func routeToTransfer() {
        self.listener?.dashboadWantToRouteToTransfer()
    }

    func routeToTopUp() {
        self.listener?.dashboadWantToRouteToTopUp()
    }
}
