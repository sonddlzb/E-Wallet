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
}

protocol TransferListener: AnyObject {
    func transferWantToDismiss()
    func transferWantToRouteToTransactionConfirm(confirmData: [String: Any], phoneNumber: String)
}

final class TransferInteractor: PresentableInteractor<TransferPresentable>, TransferInteractable {

    weak var router: TransferRouting?
    weak var listener: TransferListener?

    override init(presenter: TransferPresentable) {
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
        let confirmData: [String: Any] = ["phoneNumber": phoneNumber,
                           "name": name,
                           "amount": amount]
        self.listener?.transferWantToRouteToTransactionConfirm(confirmData: confirmData, phoneNumber: phoneNumber)
    }
}
