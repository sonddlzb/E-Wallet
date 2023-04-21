//
//  TransactionConfirmBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs

protocol TransactionConfirmDependency: Dependency {

}

final class TransactionConfirmComponent: Component<TransactionConfirmDependency> {
}

// MARK: - Builder

protocol TransactionConfirmBuildable: Buildable {
    func build(withListener listener: TransactionConfirmListener, confirmData: [String: String]) -> TransactionConfirmRouting
}

final class TransactionConfirmBuilder: Builder<TransactionConfirmDependency>, TransactionConfirmBuildable {

    override init(dependency: TransactionConfirmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TransactionConfirmListener, confirmData: [String: String]) -> TransactionConfirmRouting {
        let component = TransactionConfirmComponent(dependency: dependency)
        let viewController = TransactionConfirmViewController()
        let interactor = TransactionConfirmInteractor(presenter: viewController, confirmData: confirmData)
        interactor.listener = listener
        let selectCardBuilder = DIContainer.resolve(SelectCardBuildable.self, agrument: component)
        let enterPasswordBuilder = DIContainer.resolve(EnterPasswordBuildable.self, agrument: component)
        return TransactionConfirmRouter(interactor: interactor,
                                        viewController: viewController,
                                        selectCardBuilder: selectCardBuilder,
                                        enterPasswordBuilder: enterPasswordBuilder)
    }
}
