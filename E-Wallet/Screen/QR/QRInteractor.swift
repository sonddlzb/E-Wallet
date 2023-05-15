//
//  QRInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 12/05/2023.
//

import RIBs
import RxSwift

protocol QRRouting: ViewableRouting {
    func embedScanner()
    func embedMyQR()
}

protocol QRPresentable: Presentable {
    var listener: QRPresentableListener? { get set }
}

protocol QRListener: AnyObject {
    func qrWantToDismiss()
    func qrWantToRouteToTransfer(phoneNumber: String)
}

final class QRInteractor: PresentableInteractor<QRPresentable>, QRInteractable {

    weak var router: QRRouting?
    weak var listener: QRListener?

    override init(presenter: QRPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - QRPresentableListener
extension QRInteractor: QRPresentableListener {
    func selectScanQR() {
        self.router?.embedScanner()
    }

    func selectMyQR() {
        self.router?.embedMyQR()
    }

    func didTapBackButton() {
        self.listener?.qrWantToDismiss()
    }
}
