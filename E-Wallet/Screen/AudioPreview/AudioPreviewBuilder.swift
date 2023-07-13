//
//  AudioPreviewBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 10/07/2023.
//

import RIBs

protocol AudioPreviewDependency: Dependency {

}

final class AudioPreviewComponent: Component<AudioPreviewDependency> {
}

// MARK: - Builder

protocol AudioPreviewBuildable: Buildable {
    func build(withListener listener: AudioPreviewListener, audioURL: URL) -> AudioPreviewRouting
}

final class AudioPreviewBuilder: Builder<AudioPreviewDependency>, AudioPreviewBuildable {

    override init(dependency: AudioPreviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AudioPreviewListener, audioURL: URL) -> AudioPreviewRouting {
        let component = AudioPreviewComponent(dependency: dependency)
        let viewController = AudioPreviewViewController()
        let interactor = AudioPreviewInteractor(presenter: viewController, audioURL: audioURL)
        interactor.listener = listener
        return AudioPreviewRouter(interactor: interactor, viewController: viewController)
    }
}
