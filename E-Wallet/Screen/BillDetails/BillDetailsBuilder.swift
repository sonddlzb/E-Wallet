//
//  BillDetailsBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 08/05/2023.
//

import RIBs

protocol BillDetailsDependency: Dependency {

}

final class BillDetailsComponent: Component<BillDetailsDependency> {
}

// MARK: - Builder

protocol BillDetailsBuildable: Buildable {
    func build(withListener listener: BillDetailsListener, bill: Bill) -> BillDetailsRouting
}

final class BillDetailsBuilder: Builder<BillDetailsDependency>, BillDetailsBuildable {

    override init(dependency: BillDetailsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BillDetailsListener, bill: Bill) -> BillDetailsRouting {
        let component = BillDetailsComponent(dependency: dependency)
        let viewController = BillDetailsViewController()
        let interactor = BillDetailsInteractor(presenter: viewController, bill: bill)
        interactor.listener = listener
        return BillDetailsRouter(interactor: interactor, viewController: viewController)
    }
}
