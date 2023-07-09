//
//  PhotoPreviewBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 08/07/2023.
//

import RIBs

protocol PhotoPreviewDependency: Dependency {

}

final class PhotoPreviewComponent: Component<PhotoPreviewDependency> {
}

// MARK: - Builder

protocol PhotoPreviewBuildable: Buildable {
    func build(withListener listener: PhotoPreviewListener, image: UIImage) -> PhotoPreviewRouting
}

final class PhotoPreviewBuilder: Builder<PhotoPreviewDependency>, PhotoPreviewBuildable {

    override init(dependency: PhotoPreviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PhotoPreviewListener, image: UIImage) -> PhotoPreviewRouting {
        let component = PhotoPreviewComponent(dependency: dependency)
        let viewController = PhotoPreviewViewController()
        let interactor = PhotoPreviewInteractor(presenter: viewController, image: image)
        interactor.listener = listener
        return PhotoPreviewRouter(interactor: interactor, viewController: viewController)
    }
}
