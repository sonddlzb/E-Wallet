//
//  HomeInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs
import RxSwift

protocol HomeRouting: ViewableRouting {
    func getCurrentTabType() -> HomeTab
    func dashboardWantToReloadData()
    func routeToTab(homeTab: HomeTab)
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
}

protocol HomeListener: AnyObject {
    func routeToSignIn()
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    override init(presenter: HomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.router?.routeToTab(homeTab: .dashboard)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - HomePresentableListener
extension HomeInteractor: HomePresentableListener {
    func homeTabBarItemDidSelect(didSelect homeTab: HomeTab) {
        self.router?.routeToTab(homeTab: homeTab)
    }

    func reloadCurrentTabData() {
        if let currentTab = self.router?.getCurrentTabType() {
            switch currentTab {
            case .dashboard: self.router?.dashboardWantToReloadData()
            case .gift: print("did select gift")
            case .history: print("did select history ")
            case .account: print("did select account")
            case .myProfile: print("did select my profile")
            }
        }
    }
}
