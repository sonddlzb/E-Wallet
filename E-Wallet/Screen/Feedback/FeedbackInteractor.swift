//
//  FeedbackInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 17/07/2023.
//

import RIBs
import RxSwift
import SVProgressHUD

protocol FeedbackRouting: ViewableRouting {
}

protocol FeedbackPresentable: Presentable {
    var listener: FeedbackPresentableListener? { get set }

    func bindAddFeebackResult(isSuccess: Bool, message: String)
}

protocol FeedbackListener: AnyObject {
    func feedbackWantToDismiss()
}

final class FeedbackInteractor: PresentableInteractor<FeedbackPresentable>, FeedbackInteractable {

    weak var router: FeedbackRouting?
    weak var listener: FeedbackListener?

    override init(presenter: FeedbackPresentable) {
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

// MARK: - FeedbackPresentableListener
extension FeedbackInteractor: FeedbackPresentableListener {
    func didTapBack() {
        self.listener?.feedbackWantToDismiss()
    }

    func addFeedback(email: String, feedback: String, rating: FeedbackType) {
        SVProgressHUD.show()
        FeedbackDatabase.shared.addFeedback(email: email, feedback: feedback, rating: rating) { error, isSuccess in
            SVProgressHUD.dismiss()
            if let error = error {
                self.presenter.bindAddFeebackResult(isSuccess: false, message: error.localizedDescription)
            } else {
                if isSuccess {
                    self.presenter.bindAddFeebackResult(isSuccess: true, message: "Your feedback was sent successfully!")
                } else {
                    self.presenter.bindAddFeebackResult(isSuccess: false, message: "Something went wrong. Try again later!")
                }
            }
        }
    }
}
