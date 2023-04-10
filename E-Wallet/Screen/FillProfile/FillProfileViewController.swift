//
//  FillProfileViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import RIBs
import RxSwift
import UIKit
import DropDown
import SVProgressHUD

protocol FillProfilePresentableListener: AnyObject {
    func isFullNameValid(fullName: String) -> Bool
    func isResidentIDValid(residentId: String) -> Bool
    func isDateOfBirthValid(dateOfBirth: String) -> Bool
    func isNativePlaceValid(nativePlace: String) -> Bool
    func isGenderValid(gender: String) -> Bool
    func fillProfileWantToDismiss()
    func fillProfileWantToSignUpNewUser(userEntity: UserEntity, avatar: UIImage)
    func fillProfileWantToRouteToHome()
}

final class FillProfileViewController: UIViewController, FillProfileViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var fullNameTextField: SolarTextField!
    @IBOutlet private weak var residentIdTextField: SolarTextField!
    @IBOutlet private weak var dateOfBirthLabel: UILabel!
    @IBOutlet private weak var nativePlaceTextField: SolarTextField!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var avtImageView: UIImageView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var datePickerContainerView: UIView!
    @IBOutlet private weak var genderControl: UIControl!
    @IBOutlet private weak var dateOfBirthControl: UIControl!

    // MARK: - Variables
    private var imagePicker = UIImagePickerController()
    private var currentDate = Date()
    private var dropDown = DropDown()
    weak var listener: FillProfilePresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        fullNameTextField.placeholder = "Full Name"
        fullNameTextField.isHighlightedWhenEditting = true
        fullNameTextField.backgroundColor = .lotion
        fullNameTextField.borderColor = .crayola
        fullNameTextField.textField.paddingLeft = 10
        fullNameTextField.cornerRadius = 12
        self.becomeFirstResponder()

        residentIdTextField.placeholder = "Resident ID (9 or 12 digits)"
        residentIdTextField.isHighlightedWhenEditting = true
        residentIdTextField.backgroundColor = .lotion
        residentIdTextField.borderColor = .crayola
        residentIdTextField.textField.paddingLeft = 10
        residentIdTextField.cornerRadius = 12

        nativePlaceTextField.placeholder = "Native Place"
        nativePlaceTextField.isHighlightedWhenEditting = true
        nativePlaceTextField.backgroundColor = .lotion
        nativePlaceTextField.borderColor = .crayola
        nativePlaceTextField.textField.paddingLeft = 10
        nativePlaceTextField.cornerRadius = 12

        self.imagePicker.delegate = self
        self.datePicker.maximumDate = Date()

        self.dateOfBirthLabel.textColor = .tertiaryLabel
        self.dateOfBirthControl.addTarget(self, action: #selector(didTapDateOfBirthButton(_:)), for: .touchUpInside)

        self.genderLabel.textColor = .tertiaryLabel
        self.genderControl.addTarget(self, action: #selector(didTapGenderButton(_:)), for: .touchUpInside)
    }

    @IBAction func didTapToChangeAvatar(_ sender: TapableView) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallary()
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func openCamera() {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                PermissionHelper().requestCameraPermission(mediaType: .video) { granted, needOpenSetting in
                    if granted {
                        DispatchQueue.main.async {
                            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                            self.imagePicker.allowsEditing = true
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                    } else if needOpenSetting {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                }
            } else {
                let alert = UIAlertController(title: "Warning",
                                              message: "You don't have camera",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    }

    func openGallary() {
        PermissionHelper().requestPhotoPermission { granted, needOpenSetting in
            if granted {
                DispatchQueue.main.async {
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else if needOpenSetting {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        }
    }

    private func showDatePicker() {
        self.datePicker.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.datePickerContainerView.backgroundColor = .white
            self.datePickerContainerView.isUserInteractionEnabled = true
            self.datePicker.alpha = 1
        }

        self.datePicker.isHidden = false
    }

    private func hideDatePicker() {
        self.datePicker.alpha = 1
        UIView.animate(withDuration: 0.25) {
            self.datePickerContainerView.backgroundColor = .clear
            self.datePickerContainerView.isUserInteractionEnabled = false
            self.datePicker.alpha = 0
        }

        self.datePicker.isHidden = true
    }

    private func showDropDownMenu() {
        dropDown.dataSource = Gender.listGenders()
        dropDown.anchorView = self.genderLabel
        dropDown.bottomOffset = CGPoint(x: 0, y: genderLabel.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (_, item) in
            guard self != nil else { return }
            self?.genderLabel.text = item
            self?.genderLabel.textColor = .black
        }
    }

    private func validateSignUpForm() -> Bool {
        guard let listener = self.listener else {
            return false
        }

        if !listener.isFullNameValid(fullName: self.fullNameTextField.text) {
            FailedDialog.show(title: "Failed to sign up new account",
                              message: "Your fullname must not be empty!")
            return false
        } else if !listener.isResidentIDValid(residentId: self.residentIdTextField.text) {
            FailedDialog.show(title: "Failed to sign up new account",
                              message: "Your resident ID is not valid!")
            return false
        } else if !listener.isDateOfBirthValid(dateOfBirth: self.dateOfBirthLabel.text ?? "") {
            FailedDialog.show(title: "Failed to sign up new account",
                              message: "Your date of birth must be a valid date!")
            return false
        } else if !listener.isNativePlaceValid(nativePlace: self.nativePlaceTextField.text) {
            FailedDialog.show(title: "Failed to sign up new account",
                              message: "Your native place must not be empty!")
            return false
        } else if !listener.isGenderValid(gender: self.genderLabel.text ?? "Gender") {
            FailedDialog.show(title: "Failed to sign up new account",
                              message: "Please select your gender!")
            return false
        }

        return true
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.fillProfileWantToDismiss()
    }

    @IBAction func didChangeCalendarValue(_ sender: Any) {
        self.currentDate = datePicker.date
        self.dateOfBirthLabel.text = self.currentDate.formatDate()
        self.dateOfBirthLabel.textColor = .black
    }

    @IBAction func didTapContinueButton(_ sender: Any) {
        guard self.validateSignUpForm() else {
            return
        }

        guard let image = self.avtImageView.image else {
            return
        }

        let entity = UserEntity(fullName: self.fullNameTextField.text,
                                residentId: self.residentIdTextField.text,
                                dateOfBirth: self.currentDate.formatDate(),
                                phoneNumber: "",
                                nativePlace: self.nativePlaceTextField.text,
                                gender: self.genderLabel.text!,
                                avtURL: "",
                                password: "")
        self.listener?.fillProfileWantToSignUpNewUser(userEntity: entity, avatar: image)
    }

    @objc func didTapDateOfBirthButton(_ sender: Any) {
        showDatePicker()
    }

    @objc func didTapGenderButton(_ sender: Any) {
        showDropDownMenu()
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension FillProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.avtImageView.image = pickedImage
        }

        picker.dismiss(animated: true, completion: nil)
    }
}

extension FillProfileViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != self.dateOfBirthControl {
            self.hideDatePicker()
        }

        if touches.first?.view == self.view {
            self.view.endEditing(true)
        }
    }
}

// MARK: - FillProfilePresentable
extension FillProfileViewController: FillProfilePresentable {
    func bindSignUpResult(isSuccess: Bool) {
        if isSuccess {
            let notificationView = NotificationDialogView.loadView()
            notificationView.delegate = self
            notificationView.show(in: self.view,
                                  title: "Sign up successfully!",
                                  message: "Welcome to E-Wallet App. Let's try it right now")
        } else {
            FailedDialog.show(title: "Failed to sign up new account",
                              message: "Something went wrong. Try again later!")
        }
    }
}

// MARK: - NotificationDialogViewDelegate
extension FillProfileViewController: NotificationDialogViewDelegate {
    func notificationDialogViewDidTapOk(_ notificationDialogView: NotificationDialogView) {
        self.listener?.fillProfileWantToRouteToHome()
    }
}
