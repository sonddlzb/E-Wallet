//
//  ChatBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 11/06/2023.
//

import RIBs

protocol ChatDependency: Dependency {

}

final class ChatComponent: Component<ChatDependency> {
}

// MARK: - Builder

protocol ChatBuildable: Buildable {
    func build(withListener listener: ChatListener) -> ChatRouting
}

final class ChatBuilder: Builder<ChatDependency>, ChatBuildable {

    override init(dependency: ChatDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ChatListener) -> ChatRouting {
        let component = ChatComponent(dependency: dependency)
        let viewController = ChatViewController()
        let interactor = ChatInteractor(presenter: viewController)
        interactor.listener = listener
        return ChatRouter(interactor: interactor, viewController: viewController)
    }
}
