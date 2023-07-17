//
//  FeedbackViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 17/07/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let placeHolder = "Add your feedback here..."
}

protocol FeedbackPresentableListener: AnyObject {
    func didTapBack()
    func addFeedback(email: String, feedback: String, rating: FeedbackType)
}

final class FeedbackViewController: UIViewController, FeedbackViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var worstImageView: UIImageView!
    @IBOutlet private weak var worstLabel: UILabel!
    @IBOutlet private weak var notGoodImageView: UIImageView!
    @IBOutlet private weak var notGoodLabel: UILabel!
    @IBOutlet private weak var fineImageView: UIImageView!
    @IBOutlet private weak var fineLabel: UILabel!
    @IBOutlet private weak var lookGoodImageView: UIImageView!
    @IBOutlet private weak var lookGoodLabel: UILabel!
    @IBOutlet private weak var veryGoodImageView: UIImageView!
    @IBOutlet private weak var veryGoodLabel: UILabel!
    @IBOutlet private weak var feedbackTextView: UITextView!
    @IBOutlet private weak var emailTextField: SolarTextField!
    @IBOutlet weak var submitLabel: UILabel!
    @IBOutlet weak var submitButton: TapableView!

    private var listFeedbackImageViews: [UIImageView] = []
    private var listFeedbackLabels: [UILabel] = []

    // MARK: - Variables
    weak var listener: FeedbackPresentableListener?
    var selectedFeedback: FeedbackType = .worst {
        didSet {
            updateFeedback(feedback: selectedFeedback)
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configTextField()
        self.configTextView()

        self.listFeedbackImageViews.append(self.worstImageView)
        self.listFeedbackImageViews.append(self.notGoodImageView)
        self.listFeedbackImageViews.append(self.fineImageView)
        self.listFeedbackImageViews.append(self.lookGoodImageView)
        self.listFeedbackImageViews.append(self.veryGoodImageView)

        self.listFeedbackLabels.append(self.worstLabel)
        self.listFeedbackLabels.append(self.notGoodLabel)
        self.listFeedbackLabels.append(self.fineLabel)
        self.listFeedbackLabels.append(self.lookGoodLabel)
        self.listFeedbackLabels.append(self.veryGoodLabel)
    }

    private func configTextField() {
        self.emailTextField.cornerRadius = 10.0
        self.emailTextField.borderWidth = 1.0
        self.emailTextField.borderColor = .black
        self.emailTextField.isLeftButtonEnable = false
        self.emailTextField.paddingLeft = 20.0
        self.emailTextField.placeholder = "xyz123@gmail.com"
        self.emailTextField.isHighlightedWhenEditting = true
        self.emailTextField.borderColor = .crayola
        self.emailTextField.backgroundColor = UIColor(rgb: 0xF5F5F5)
        self.emailTextField.shadowColor = .black
        self.emailTextField.shadowOffset = CGSize(width: 0, height: 3.0)
        self.emailTextField.shadowOpacity = 0.4
        self.emailTextField.shadowRadius = 5.0
        self.emailTextField.clipsToBounds = false
    }

    private func configTextView() {
        self.feedbackTextView.text = Const.placeHolder
        self.feedbackTextView.textColor = .lightGray
        self.feedbackTextView.delegate = self
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBack()
    }

    @IBAction func didTapNotGoodFeedback(_ sender: Any) {
        self.selectedFeedback = .notGood
    }

    @IBAction func didTapFineFeedback(_ sender: Any) {
        self.selectedFeedback = .fine
    }

    @IBAction func didTapLookGoodFeedback(_ sender: Any) {
        self.selectedFeedback = .lookGood
    }

    @IBAction func didTapWorstFeedback(_ sender: Any) {
        self.selectedFeedback = .worst
    }

    @IBAction func didTapVeryGoodFeedback(_ sender: Any) {
        self.selectedFeedback = .veryGood
    }

    @IBAction func didTapSubmitButton(_ sender: Any) {
        let email = self.emailTextField.text
        guard email.isEmailValid() else {
            FailedDialog.show(title: "Failed to add feedback",
                              message: "Your email is invalid!")
            return
        }

        self.listener?.addFeedback(email: email, feedback: self.feedbackTextView.text, rating: self.selectedFeedback)
    }

    // MARK: - Helpers
    func resetFeedback() {
        for index in 0...self.listFeedbackImageViews.count-1 {
            self.listFeedbackImageViews[index].image = FeedbackType.allCases[index].image(isFocus: false)
            self.listFeedbackLabels[index].textColor = .crayola.withAlphaComponent(0.3)
        }
    }

    func selectFeedback(_ feedback: FeedbackType) {
        self.resetFeedback()
        for (index, value) in FeedbackType.allCases.enumerated() {
            if feedback == value {
                self.listFeedbackImageViews[index].image = FeedbackType.allCases[index].image(isFocus: true)
                self.listFeedbackLabels[index].textColor = .crayola.withAlphaComponent(1.0)
            }
        }
    }

    func updateFeedback(feedback: FeedbackType) {
        self.selectFeedback(feedback)
    }
}

extension FeedbackViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension FeedbackViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.isEmpty || textView.text == Const.placeHolder {
            self.submitButton.isUserInteractionEnabled = false
            self.submitLabel.backgroundColor = .lightGray
        } else {
            self.submitButton.isUserInteractionEnabled = true
            self.submitLabel.backgroundColor = .crayola
        }

        return true
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Const.placeHolder {
            textView.text = ""
            textView.textColor = .black
        }

        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = Const.placeHolder
            textView.textColor = .lightGray
        }

        return true
    }
}

// MARK: - FeedbackPresentable
extension FeedbackViewController: FeedbackPresentable {
    func bindAddFeebackResult(isSuccess: Bool, message: String) {
        if isSuccess {
            let notificationView = NotificationDialogView.loadView()
            notificationView.delegate = self
            notificationView.show(in: self.view, title: "Successfully", message: message)
        } else {
            FailedDialog.show(title: "Oh no!", message: message)
        }
    }
}

// MARK: - NotificationDialogViewDelegate
extension FeedbackViewController: NotificationDialogViewDelegate {
    func notificationDialogViewDidTapOk(_ notificationDialogView: NotificationDialogView) {
        self.listener?.didTapBack()
    }
}
