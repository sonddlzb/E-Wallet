//
//  EditProfileViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 12/04/2023.
//

import RIBs
import RxSwift
import UIKit
import DropDown

protocol EditProfilePresentableListener: AnyObject {
    func editProfileWantToDismiss()
    func editProfileWantToUpdate(userEntity: UserEntity, avatar: UIImage)
    func isFullNameValid(fullName: String) -> Bool
    func isResidentIDValid(residentId: String) -> Bool
    func isDateOfBirthValid(dateOfBirth: String) -> Bool
    func isNativePlaceValid(nativePlace: String) -> Bool
    func isGenderValid(gender: String) -> Bool
}

final class EditProfileViewController: UIViewController, EditProfileViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var fullNameTextField: SolarTextField!
    @IBOutlet private weak var residentIdTextField: SolarTextField!
    @IBOutlet private weak var dateOfBirthLabel: UILabel!
    @IBOutlet private weak var editLabel: UILabel!
    @IBOutlet private weak var nativePlaceTextField: SolarTextField!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var avtImageView: UIImageView!
    @IBOutlet private weak var calendarImageView: UIImageView!
    @IBOutlet private weak var arrowDownImageView: UIImageView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var datePickerContainerView: UIView!
    @IBOutlet private weak var genderControl: UIControl!
    @IBOutlet private weak var dateOfBirthControl: UIControl!
    @IBOutlet private weak var editButton: TapableView!
    @IBOutlet private weak var changeAvtButton: TapableView!

    // MARK: - Variables
    private var imagePicker = UIImagePickerController()
    private var currentDate = Date()
    private var dropDown = DropDown()
    weak var listener: EditProfilePresentableListener?
    private var viewModel: EditProfileViewModel!
    var isEditable = false {
        didSet {
            self.fullNameTextField.isUserInteractionEnabled = isEditable
            self.residentIdTextField.isUserInteractionEnabled = isEditable
            self.dateOfBirthControl.isUserInteractionEnabled = isEditable
            self.nativePlaceTextField.isUserInteractionEnabled = isEditable
            self.genderControl.isUserInteractionEnabled = isEditable
            self.arrowDownImageView.isHidden = !isEditable
            self.calendarImageView.isHidden = !isEditable
            self.changeAvtButton.isUserInteractionEnabled = isEditable
        }
    }

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
        fullNameTextField.delegate = self
        self.becomeFirstResponder()

        residentIdTextField.placeholder = "Resident ID (9 or 12 digits)"
        residentIdTextField.isHighlightedWhenEditting = true
        residentIdTextField.backgroundColor = .lotion
        residentIdTextField.borderColor = .crayola
        residentIdTextField.textField.paddingLeft = 10
        residentIdTextField.delegate = self
        residentIdTextField.cornerRadius = 12

        nativePlaceTextField.placeholder = "Native Place"
        nativePlaceTextField.isHighlightedWhenEditting = true
        nativePlaceTextField.backgroundColor = .lotion
        nativePlaceTextField.borderColor = .crayola
        nativePlaceTextField.textField.paddingLeft = 10
        nativePlaceTextField.cornerRadius = 12
        nativePlaceTextField.delegate = self

        self.imagePicker.delegate = self
        self.datePicker.maximumDate = Date()

        self.dateOfBirthControl.addTarget(self, action: #selector(didTapDateOfBirthButton(_:)), for: .touchUpInside)

        self.genderControl.addTarget(self, action: #selector(didTapGenderButton(_:)), for: .touchUpInside)

        self.isEditable = false
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

    private func validateProfileForm() -> Bool {
        guard let listener = self.listener else {
            return false
        }

        if !listener.isFullNameValid(fullName: self.fullNameTextField.text) {
            return false
        } else if !listener.isResidentIDValid(residentId: self.residentIdTextField.text) {
            return false
        } else if !listener.isDateOfBirthValid(dateOfBirth: self.dateOfBirthLabel.text ?? "") {
            return false
        } else if !listener.isNativePlaceValid(nativePlace: self.nativePlaceTextField.text) {
            return false
        } else if !listener.isGenderValid(gender: self.genderLabel.text ?? "Gender") {
            return false
        }

        return true
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.editProfileWantToDismiss()
    }

    @IBAction func didChangeCalendarValue(_ sender: Any) {
        self.currentDate = datePicker.date
        self.dateOfBirthLabel.text = self.currentDate.formatDate()
        self.dateOfBirthLabel.textColor = .black
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

    @IBAction func didTapEditButton(_ sender: Any) {
        self.isEditable = !self.isEditable
        self.editLabel.text = self.isEditable ? "Save" : "Edit"
        if self.isEditable {
            self.fullNameTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            self.hideDatePicker()

            guard self.validateProfileForm() else {
                return
            }

            guard let image = self.avtImageView.image?.resize(to: CGSize(width: 100.0, height: 100.0)) else {
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
            self.listener?.editProfileWantToUpdate(userEntity: entity, avatar: image)
        }
    }

    @objc func didTapDateOfBirthButton(_ sender: Any) {
        showDatePicker()
    }

    @objc func didTapGenderButton(_ sender: Any) {
        showDropDownMenu()
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.avtImageView.image = pickedImage
        }

        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != self.dateOfBirthControl {
            self.hideDatePicker()
        }

        if touches.first?.view == self.view {
            self.view.endEditing(true)
        }
    }
}

// MARK: - EditProfilePresentable
extension EditProfileViewController: EditProfilePresentable {
    func bind(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.fullNameTextField.text = viewModel.userEntity.fullName
        self.residentIdTextField.text = viewModel.userEntity.residentId
        self.dateOfBirthLabel.text = viewModel.userEntity.dateOfBirth
        self.dateOfBirthLabel.textColor = .black
        self.nativePlaceTextField.text = viewModel.userEntity.nativePlace
        self.genderLabel.text = viewModel.userEntity.gender
        self.genderLabel.textColor = .black
        self.avtImageView.setImage(with: URL(string: self.viewModel.userEntity.avtURL),
                                   indicator: .activity)
    }

    func bindUpdateResult(isSuccess: Bool) {
        if isSuccess {
            let notificationDialogView = NotificationDialogView.loadView()
            notificationDialogView.delegate = self
            notificationDialogView.show(in: self.view, title: "Update information", message: "Your information was updated successfully!")
        } else {
            FailedDialog.show(title: "Update information", message: "Something went wrong. Try again later!")
        }
    }
}

// MARK: - SolarTextFieldDelegate
extension EditProfileViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }

    func solarTextFieldDidChangeValue(_ textField: SolarTextField) {
        let isInputValid = self.validateProfileForm()
        self.editButton.isUserInteractionEnabled = isInputValid
        self.editLabel.textColor = isInputValid ? UIColor(rgb: 0x007AFF) : .mediumGray
    }
}

// MARK: - NotificationDialogViewDelegate
extension EditProfileViewController: NotificationDialogViewDelegate {
    func notificationDialogViewDidTapOk(_ notificationDialogView: NotificationDialogView) {
        self.listener?.editProfileWantToDismiss()
    }
}
