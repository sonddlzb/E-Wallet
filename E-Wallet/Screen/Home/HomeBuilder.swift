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
        let accountBuilder = DIContainer.resolve(AccountBuildable.self, agrument: component)
        let topUpBuilder = DIContainer.resolve(TopUpBuildable.self, agrument: component)
        let addCardBuilder = DIContainer.resolve(AddCardBuildable.self, agrument: component)
        let withdrawBuilder = DIContainer.resolve(WithdrawBuildable.self, agrument: component)
        let transactionConfirmBuilder = DIContainer.resolve(TransactionConfirmBuildable.self, agrument: component)
        return HomeRouter(interactor: interactor,
                          viewController: viewController,
                          dashboardBuilder: dashboardBuilder,
                          profileBuilder: profileBuilder,
                          transferBuilder: transferBuilder,
                          accountBuilder: accountBuilder,
                          topUpBuilder: topUpBuilder,
                          addCardBuilder: addCardBuilder,
                          withdrawBuilder: withdrawBuilder,
                          transactionConfirmBuilder: transactionConfirmBuilder)
    }
}
