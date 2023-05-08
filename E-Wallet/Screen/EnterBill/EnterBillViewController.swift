//
//  EnterBillViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import RIBs
import RxSwift
import UIKit

protocol EnterBillPresentableListener: AnyObject {
    func didTapBackButton()
    func didSelectCheck(customerId: String)
}

final class EnterBillViewController: UIViewController, EnterBillViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var customerTextField: SolarTextField!
    @IBOutlet private weak var checkButton: TapableView!
    @IBOutlet private weak var checkLabel: UILabel!
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Variables
    weak var listener: EnterBillPresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    private func config() {
        customerTextField.placeholder = "Enter Customer ID"
        customerTextField.isHighlightedWhenEditting = true
        customerTextField.backgroundColor = .lotion
        customerTextField.borderColor = .crayola
        customerTextField.textField.paddingLeft = 10
        customerTextField.cornerRadius = 12
        customerTextField.delegate = self

        self.checkButton.isUserInteractionEnabled = false
        self.checkLabel.backgroundColor = .lightGray
        self.warningLabel.isHidden = true
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBackButton()
    }

    @IBAction func didTapCheckButton(_ sender: Any) {
        self.listener?.didSelectCheck(customerId: self.customerTextField.text)
    }
}

// MARK: - SolarTextFieldDelegate
extension EnterBillViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        self.checkButton.isUserInteractionEnabled = !text.isEmpty
        self.checkLabel.backgroundColor = text.isEmpty ? .lightGray : .crayola
        self.customerTextField.isValid = true
        self.warningLabel.isHidden = true
        return true
    }
}

extension EnterBillViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - EnterBillPresentable
extension EnterBillViewController: EnterBillPresentable {
    func bindCheckBillFailedResult() {
        self.customerTextField.isValid = false
        self.warningLabel.isHidden = false
    }

    func bind(viewModel: EnterBillViewModel) {
        self.loadViewIfNeeded()
        self.imageView.image = viewModel.image()
        self.nameLabel.text = viewModel.name()
    }
}
