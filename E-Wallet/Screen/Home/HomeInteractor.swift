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
    func bindDataToHomeTab(viewModel: HomeViewModel)
    func routeToTransfer()
    func dismissTransfer()
    func routeToTopUp()
    func dismissTopUp()
    func routeToAddCard()
    func dismissAddCard()
    func reloadCardData()
    func routeToWithdraw()
    func dismissWithdraw()
    func routeToTransactionConfirm(confirmData: [String: String])
    func dismissTransactionConfirm()
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
    private var viewModel: HomeViewModel!

    override init(presenter: HomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.router?.routeToTab(homeTab: .dashboard)
        self.fetchUserInfor()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func fetchUserInfor() {
        UserDatabase.shared.getUserInfor { user in
            if let user = user {
                AccountDatabase.shared.getAccountInfor { account in
                    self.viewModel = HomeViewModel(userEntity: user, accountEntity: account)
                    self.router?.bindDataToHomeTab(viewModel: self.viewModel)
                }
            }
        }
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
