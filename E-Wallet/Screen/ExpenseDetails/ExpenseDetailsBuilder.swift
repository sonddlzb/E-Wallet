//
//  ExpenseDetailsBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 24/05/2023.
//

import RIBs

protocol ExpenseDetailsDependency: Dependency {

}

final class ExpenseDetailsComponent: Component<ExpenseDetailsDependency> {
}

// MARK: - Builder

protocol ExpenseDetailsBuildable: Buildable {
    func build(withListener listener: ExpenseDetailsListener, startDate: Date) -> ExpenseDetailsRouting
}

final class ExpenseDetailsBuilder: Builder<ExpenseDetailsDependency>, ExpenseDetailsBuildable {

    override init(dependency: ExpenseDetailsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ExpenseDetailsListener, startDate: Date) -> ExpenseDetailsRouting {
        let component = ExpenseDetailsComponent(dependency: dependency)
        let viewController = ExpenseDetailsViewController()
        let interactor = ExpenseDetailsInteractor(presenter: viewController, startDate: startDate)
        interactor.listener = listener
        return ExpenseDetailsRouter(interactor: interactor, viewController: viewController)
    }
}
