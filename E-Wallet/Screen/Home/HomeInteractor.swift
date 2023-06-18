//
//  HomeInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs
import RxSwift
import UserNotifications

protocol HomeRouting: ViewableRouting {
    func getCurrentTabType() -> HomeTab
    func dashboardWantToReloadData()
    func routeToTab(homeTab: HomeTab)
    func bindDataToHomeTab(viewModel: HomeViewModel)
    func routeToTransfer(phoneNumber: String?)
    func dismissTransfer(animated: Bool)
    func routeToTopUp()
    func dismissTopUp(animated: Bool)
    func routeToAddCard()
    func dismissAddCard(animated: Bool)
    func reloadCardData()
    func routeToWithdraw()
    func dismissWithdraw(animated: Bool)
    func routeToTransactionConfirm(confirmData: [String: String], isShowPaymentMethodView: Bool)
    func dismissTransactionConfirm(animated: Bool)
    func routeBackToHome()
    func receiptWantToSeeDetails(transaction: Transaction)
    func routeToEnterBill(serviceType: ServiceType)
    func dismissEnterBill(animated: Bool)
    func routeToQR()
    func dismissQR()
    func openTransactionDetails(transaction: Transaction)
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }

    func selectHistoryTab()
    func showNotification(message: NotificationMessage)
}

protocol HomeListener: AnyObject {
    func routeToSignIn()
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable {

    weak var router: HomeRouting?
    weak var listener: HomeListener?
    private var viewModel: HomeViewModel!
    var message: NotificationMessage?

    override init(presenter: HomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.router?.routeToTab(homeTab: .dashboard)
        self.fetchUserInfor()
        self.subscribeNotification()
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

    func subscribeNotification() {
        NotificationDatabase.shared.subscribeNotification { message in
            guard let message = message else {
                return
            }

            self.message = message
            guard Date().timeIntervalSinceReferenceDate - message.time.timeIntervalSinceReferenceDate < 10.0 else {
                return
            }

            self.presenter.showNotification(message: message)
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
            case .chat: print("did select chat")
            case .myProfile: print("did select my profile")
            }
        }
    }

    func didSelectNotification() {
        guard let message = self.message else {
            return
        }

        TransactionDatabase.shared.fetchTransactionBy(id: message.transactionId) { [weak self] transaction in
            if let transaction = transaction {
                DispatchQueue.main.async {
                    self?.router?.openTransactionDetails(transaction: transaction)
                }
            }
        }
    }
}
