//
//  HomeBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs

protocol HomeDependency: Dependency {

}

final class HomeComponent: Component<HomeDependency> {
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener) -> HomeRouting {
        let component = HomeComponent(dependency: dependency)
        let viewController = HomeViewController()
        let interactor = HomeInteractor(presenter: viewController)
        interactor.listener = listener
        let dashboardBuilder = DIContainer.resolve(DashboardBuildable.self, agrument: component)
        let profileBuilder = DIContainer.resolve(ProfileBuildable.self, agrument: component)
        let transferBuilder = DIContainer.resolve(TransferBuildable.self, agrument: component)
        let topUpBuilder = DIContainer.resolve(TopUpBuildable.self, agrument: component)
        let addCardBuilder = DIContainer.resolve(AddCardBuildable.self, agrument: component)
        let withdrawBuilder = DIContainer.resolve(WithdrawBuildable.self, agrument: component)
        let transactionConfirmBuilder = DIContainer.resolve(TransactionConfirmBuildable.self, agrument: component)
        let historyBuilder = DIContainer.resolve(HistoryBuildable.self, agrument: component)
        let giftBuilder = DIContainer.resolve(GiftBuildable.self, agrument: component)
        let enterBillBuilder = DIContainer.resolve(EnterBillBuildable.self, agrument: component)
        let qrBuilder = DIContainer.resolve(QRBuildable.self, agrument: component)
        let chatBuilder = DIContainer.resolve(ChatBuildable.self, agrument: component)
        return HomeRouter(interactor: interactor,
                          viewController: viewController,
                          dashboardBuilder: dashboardBuilder,
                          profileBuilder: profileBuilder,
                          transferBuilder: transferBuilder,
                          topUpBuilder: topUpBuilder,
                          addCardBuilder: addCardBuilder,
                          withdrawBuilder: withdrawBuilder,
                          transactionConfirmBuilder: transactionConfirmBuilder,
                          historyBuilder: historyBuilder,
                          giftBuilder: giftBuilder,
                          enterBillBuilder: enterBillBuilder,
                          qrBuilder: qrBuilder,
                          chatBuilder: chatBuilder)
    }
}
