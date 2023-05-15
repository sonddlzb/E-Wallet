//
//  ScannerBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 11/05/2023.
//

import RIBs

protocol ScannerDependency: Dependency {

}

final class ScannerComponent: Component<ScannerDependency> {
}

// MARK: - Builder

protocol ScannerBuildable: Buildable {
    func build(withListener listener: ScannerListener) -> ScannerRouting
}

final class ScannerBuilder: Builder<ScannerDependency>, ScannerBuildable {

    override init(dependency: ScannerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ScannerListener) -> ScannerRouting {
        let component = ScannerComponent(dependency: dependency)
        let viewController = ScannerViewController()
        let interactor = ScannerInteractor(presenter: viewController)
        interactor.listener = listener
        return ScannerRouter(interactor: interactor, viewController: viewController)
    }
}
