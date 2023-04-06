//
//  SignUpInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import RIBs
import RxSwift
import FirebaseAuth

protocol SignUpRouting: ViewableRouting {
    func routeToVerifyCode(verificationID: String, phoneNumber: String)
    func dismissVerifyCode()
}

protocol SignUpPresentable: Presentable {
    var listener: SignUpPresentableListener? { get set }
}

protocol SignUpListener: AnyObject {
    func signUpWantToRouteToSignIn()
}

final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable {

    weak var router: SignUpRouting?
    weak var listener: SignUpListener?

    override init(presenter: SignUpPresentable) {
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

// MARK: - SignUpPresentableListener
extension SignUpInteractor: SignUpPresentableListener {
    func routeToSignIn() {
        self.listener?.signUpWantToRouteToSignIn()
    }

    func signUpWithPhoneNumber(_ phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error when verify phone number: \(error)")
                return
            } else {
                self.router?.routeToVerifyCode(verificationID: verificationID!, phoneNumber: phoneNumber)
            }
        }
    }
}
