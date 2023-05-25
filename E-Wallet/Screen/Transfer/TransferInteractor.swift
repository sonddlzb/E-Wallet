//
//  TransferInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 13/04/2023.
//

import RIBs
import RxSwift
import Contacts

protocol TransferRouting: ViewableRouting {
}

protocol TransferPresentable: Presentable {
    var listener: TransferPresentableListener? { get set }

    func openContactsVC()
    func bind(phoneNumber: String)
}

protocol TransferListener: AnyObject {
    func transferWantToDismiss()
    func transferWantToRouteToTransactionConfirm(confirmData: [String: String])
    func transferWantToRouteToQRScanner()
}

final class TransferInteractor: PresentableInteractor<TransferPresentable>, TransferInteractable {

    weak var router: TransferRouting?
    weak var listener: TransferListener?
    private var phoneNumber: String?

    init(presenter: TransferPresentable, phoneNumber: String?) {
        self.phoneNumber = phoneNumber
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        if let phoneNumber = self.phoneNumber {
            self.presenter.bind(phoneNumber: phoneNumber)
        }
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - TransferPresentableListener
extension TransferInteractor: TransferPresentableListener {
    func transferWantToDismiss() {
        self.listener?.transferWantToDismiss()
    }

    func openContacts() {
        PermissionHelper().requestContactsPermission { granted, isNeedOpenSetting in
            if granted {
                self.presenter.openContactsVC()
            } else if isNeedOpenSetting {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        }
    }

    func getNameBy(phoneNumber: String, completion: @escaping (String) -> Void) {
        UserDatabase.shared.getUsernameBy(phoneNumber: phoneNumber) { name in
            DispatchQueue.main.async {
                completion(name)
            }
        }
    }

    func routeToTransactionConfirm(phoneNumber: String, name: String, amount: Double) {
        let confirmData: [String: String] = ["Payment Type": "Transfer",
                                             "Phone number": phoneNumber.formatPhoneNumber(),
                                             "Name": name,
                                             "Amount": "$" + String(amount)]
        self.listener?.transferWantToRouteToTransactionConfirm(confirmData: confirmData)
    }

    func didSelectQR() {
        self.listener?.transferWantToRouteToQRScanner()
    }
}
