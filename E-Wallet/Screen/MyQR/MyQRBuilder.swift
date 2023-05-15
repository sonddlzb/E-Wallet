//
//  MyQRBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 12/05/2023.
//

import RIBs

protocol MyQRDependency: Dependency {

}

final class MyQRComponent: Component<MyQRDependency> {
}

// MARK: - Builder

protocol MyQRBuildable: Buildable {
    func build(withListener listener: MyQRListener) -> MyQRRouting
}

final class MyQRBuilder: Builder<MyQRDependency>, MyQRBuildable {

    override init(dependency: MyQRDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyQRListener) -> MyQRRouting {
        let component = MyQRComponent(dependency: dependency)
        let viewController = MyQRViewController()
        let interactor = MyQRInteractor(presenter: viewController)
        interactor.listener = listener
        return MyQRRouter(interactor: interactor, viewController: viewController)
    }
}
