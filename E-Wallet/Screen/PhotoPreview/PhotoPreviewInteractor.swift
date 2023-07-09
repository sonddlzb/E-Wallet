//
//  PhotoPreviewInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 08/07/2023.
//

import RIBs
import RxSwift

protocol PhotoPreviewRouting: ViewableRouting {
}

protocol PhotoPreviewPresentable: Presentable {
    var listener: PhotoPreviewPresentableListener? { get set }

    func bind(viewModel: PhotoPreviewViewModel)
}

protocol PhotoPreviewListener: AnyObject {
    func photoPreviewWantToDismiss()
}

final class PhotoPreviewInteractor: PresentableInteractor<PhotoPreviewPresentable>, PhotoPreviewInteractable {

    weak var router: PhotoPreviewRouting?
    weak var listener: PhotoPreviewListener?
    var viewModel: PhotoPreviewViewModel

    init(presenter: PhotoPreviewPresentable, image: UIImage) {
        self.viewModel = PhotoPreviewViewModel(image: image)
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - PhotoPreviewPresentableListener
extension PhotoPreviewInteractor: PhotoPreviewPresentableListener {
    func didTapCancel() {
        self.listener?.photoPreviewWantToDismiss()
    }
}
