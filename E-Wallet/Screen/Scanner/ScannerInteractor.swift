//
//  ScannerInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 11/05/2023.
//

import RIBs
import RxSwift

protocol ScannerRouting: ViewableRouting {
}

protocol ScannerPresentable: Presentable {
    var listener: ScannerPresentableListener? { get set }
}

protocol ScannerListener: AnyObject {
    func scannerWantToRouteToTransfer(phoneNumber: String)
}

final class ScannerInteractor: PresentableInteractor<ScannerPresentable>, ScannerInteractable {

    weak var router: ScannerRouting?
    weak var listener: ScannerListener?

    override init(presenter: ScannerPresentable) {
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

// MARK: - ScannerPresentableListener
extension ScannerInteractor: ScannerPresentableListener {
    func handleQRScanningResult(text: String) {
        guard text.isPhoneNumberValid() else {
            return
        }

        self.listener?.scannerWantToRouteToTransfer(phoneNumber: text)
    }
}
