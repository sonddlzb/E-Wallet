//
//  QRBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 12/05/2023.
//

import RIBs

protocol QRDependency: Dependency {

}

final class QRComponent: Component<QRDependency> {
}

// MARK: - Builder

protocol QRBuildable: Buildable {
    func build(withListener listener: QRListener) -> QRRouting
}

final class QRBuilder: Builder<QRDependency>, QRBuildable {

    override init(dependency: QRDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: QRListener) -> QRRouting {
        let component = QRComponent(dependency: dependency)
        let viewController = QRViewController()
        let interactor = QRInteractor(presenter: viewController)
        interactor.listener = listener
        let scannerBuilder = DIContainer.resolve(ScannerBuildable.self, agrument: component)
        let myQRBuilder = DIContainer.resolve(MyQRBuildable.self, agrument: component)
        return QRRouter(interactor: interactor,
                        viewController: viewController,
                        scannerBuilder: scannerBuilder,
                        myQRBuilder: myQRBuilder)
    }
}
