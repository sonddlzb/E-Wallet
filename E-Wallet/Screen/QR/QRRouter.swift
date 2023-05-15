//
//  QRRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 12/05/2023.
//

import RIBs

protocol QRInteractable: Interactable, ScannerListener, MyQRListener {
    var router: QRRouting? { get set }
    var listener: QRListener? { get set }
}

protocol QRViewControllable: ViewControllable {
    func embedViewController(_ viewController: ViewControllable)
}

final class QRRouter: ViewableRouter<QRInteractable, QRViewControllable> {

    private var scannerRouter: ScannerRouting?
    private var scannerBuilder: ScannerBuildable

    private var myQRRouter: MyQRRouting?
    private var myQRBuilder: MyQRBuildable

    init(interactor: QRInteractable,
         viewController: QRViewControllable,
         scannerBuilder: ScannerBuildable,
         myQRBuilder: MyQRBuildable) {
        self.scannerBuilder = scannerBuilder
        self.myQRBuilder = myQRBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - QRRouting
extension QRRouter: QRRouting {
    func embedScanner() {
        if self.scannerRouter == nil {
            self.scannerRouter = self.scannerBuilder.build(withListener: self.interactor)
            attachChild(self.scannerRouter!)
        }

        self.viewController.embedViewController(self.scannerRouter!.viewControllable)
    }

    func embedMyQR() {
        if self.myQRRouter == nil {
            self.myQRRouter = self.myQRBuilder.build(withListener: self.interactor)
            attachChild(self.myQRRouter!)
        }

        self.viewController.embedViewController(self.myQRRouter!.viewControllable)
    }
}
