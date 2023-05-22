//
//  ExpenseBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 15/05/2023.
//

import RIBs

protocol ExpenseDependency: Dependency {

}

final class ExpenseComponent: Component<ExpenseDependency> {
}

// MARK: - Builder

protocol ExpenseBuildable: Buildable {
    func build(withListener listener: ExpenseListener) -> ExpenseRouting
}

final class ExpenseBuilder: Builder<ExpenseDependency>, ExpenseBuildable {

    override init(dependency: ExpenseDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ExpenseListener) -> ExpenseRouting {
        let component = ExpenseComponent(dependency: dependency)
        let viewController = ExpenseViewController()
        let interactor = ExpenseInteractor(presenter: viewController)
        interactor.listener = listener
        return ExpenseRouter(interactor: interactor, viewController: viewController)
    }
}
