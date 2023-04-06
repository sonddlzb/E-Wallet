//
//  VerifyCodeInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import RIBs
import RxSwift
import FirebaseAuth

protocol VerifyCodeRouting: ViewableRouting {
}

protocol VerifyCodePresentable: Presentable {
    var listener: VerifyCodePresentableListener? { get set }

    func showFailedDialog(title: String, message: String)
}

protocol VerifyCodeListener: AnyObject {
    func verifyCodeWantToDismiss()
    func verifyCodeSuccessfully(isNewUser: Bool)
}

final class VerifyCodeInteractor: PresentableInteractor<VerifyCodePresentable>, VerifyCodeInteractable {

    weak var router: VerifyCodeRouting?
    weak var listener: VerifyCodeListener?
    private var verificationID: String

    init(presenter: VerifyCodePresentable, verificationID: String) {
        self.verificationID = verificationID
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

// MARK: - VerifyCodePresentableListener
extension VerifyCodeInteractor: VerifyCodePresentableListener {
    func verifyCodeWantToDismiss() {
        self.listener?.verifyCodeWantToDismiss()
    }

    func verifyPhoneNumber(verificationCode: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Error when sign in with phone number: \(error)")
                        self.presenter.showFailedDialog(title: "Verify OTP failed", message: error.localizedDescription)
                    } else {
                        let isNewUser = authResult?.additionalUserInfo?.isNewUser ?? false
                        self.listener?.verifyCodeSuccessfully(isNewUser: isNewUser)
                    }
                }
    }

    func verifyCodeWantToResendCode(for phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error when verify phone number: \(error)")
                self.presenter.showFailedDialog(title: "Verify OTP failed", message: error.localizedDescription)
                return
            } else {
                self.verificationID = verificationID!
                print("Resend successfully")
            }
        }
    }
}
