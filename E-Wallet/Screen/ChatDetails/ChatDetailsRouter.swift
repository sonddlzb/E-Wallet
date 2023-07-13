//
//  ChatDetailsRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import RIBs

protocol ChatDetailsInteractable: Interactable, TransactionDetailsListener, PhotoPreviewListener, AudioPreviewListener {
    var router: ChatDetailsRouting? { get set }
    var listener: ChatDetailsListener? { get set }
}

protocol ChatDetailsViewControllable: ViewControllable {
}

final class ChatDetailsRouter: ViewableRouter<ChatDetailsInteractable, ChatDetailsViewControllable> {
    private var transactionDetailsRouter: TransactionDetailsRouting?
    private var transactionDetailsBuilder: TransactionDetailsBuildable

    private var photoPreviewBuilder: PhotoPreviewBuildable
    private var photoPreviewRouter: PhotoPreviewRouting?

    private var audioPreviewBuilder: AudioPreviewBuildable
    private var audioPreviewRouter: AudioPreviewRouting?

    init(interactor: ChatDetailsInteractable,
         viewController: ChatDetailsViewControllable,
         transactionDetailsBuilder: TransactionDetailsBuildable,
         photoPreviewBuilder: PhotoPreviewBuildable,
         audioPreviewBuilder: AudioPreviewBuildable) {
        self.audioPreviewBuilder = audioPreviewBuilder
        self.photoPreviewBuilder = photoPreviewBuilder
        self.transactionDetailsBuilder = transactionDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension ChatDetailsRouter: ChatDetailsRouting {
    func openHistory(at transaction: Transaction) {
        guard self.transactionDetailsRouter == nil else {
            return
        }

        let router = self.transactionDetailsBuilder.build(withListener: self.interactor, transaction: transaction)
        self.attachChild(router)
        self.viewControllable.push(viewControllable: router.viewControllable)
        self.transactionDetailsRouter = router
    }

    func dismissHistory() {
        guard let router = self.transactionDetailsRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.transactionDetailsRouter = nil
    }

    func routeToPhotoPreview(image: UIImage) {
        guard self.photoPreviewRouter == nil else {
            return
        }

        let router = self.photoPreviewBuilder.build(withListener: self.interactor, image: image)
        self.attachChild(router)
        router.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        self.viewControllable.present(viewControllable: router.viewControllable, animated: true)
        self.photoPreviewRouter = router
    }

    func dismissPhotoPreview() {
        guard let router = self.photoPreviewRouter else {
            return
        }

        self.detachChild(router)
        router.viewControllable.dismiss(animated: true)
        self.photoPreviewRouter = nil
    }

    func routeToAudioPreview(audioURL: URL) {
        guard self.audioPreviewRouter == nil else {
            return
        }

        let router = self.audioPreviewBuilder.build(withListener: self.interactor, audioURL: audioURL)
        self.attachChild(router)
        self.viewControllable.uiviewController.presentCustomViewController(router.viewControllable.uiviewController, rate: 0.4)
        self.audioPreviewRouter = router
    }

    func dismissAudioPreview() {
        guard let router = self.audioPreviewRouter else {
            return
        }

        self.detachChild(router)
        router.viewControllable.uiviewController.dismissCustomViewController()
        self.audioPreviewRouter = nil
    }
}
