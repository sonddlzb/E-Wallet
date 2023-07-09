//
//  ChatDetailsBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import RIBs

protocol ChatDetailsDependency: Dependency {

}

final class ChatDetailsComponent: Component<ChatDetailsDependency> {
}

// MARK: - Builder

protocol ChatDetailsBuildable: Buildable {
    func build(withListener listener: ChatDetailsListener, talker: User) -> ChatDetailsRouting
}

final class ChatDetailsBuilder: Builder<ChatDetailsDependency>, ChatDetailsBuildable {

    override init(dependency: ChatDetailsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ChatDetailsListener, talker: User) -> ChatDetailsRouting {
        let component = ChatDetailsComponent(dependency: dependency)
        let viewController = ChatDetailsViewController()
        let interactor = ChatDetailsInteractor(presenter: viewController, talker: talker)
        interactor.listener = listener
        let transactionDetailsBuilder = DIContainer.resolve(TransactionDetailsBuildable.self, agrument: component)
        let photoPreviewBuilder = DIContainer.resolve(PhotoPreviewBuildable.self, agrument: component)
        return ChatDetailsRouter(interactor: interactor,
                                 viewController: viewController,
                                 transactionDetailsBuilder: transactionDetailsBuilder,
                                 photoPreviewBuilder: photoPreviewBuilder)
    }
}
