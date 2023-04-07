//
//  SignInInteractor+FillProfile.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import Foundation
import SVProgressHUD

extension SignInInteractor: FillProfileListener {
    func fillProfileWantToDismiss() {
        self.router?.dismissFillProfile()
    }

    func fillProfileWantToSignUpNewUser(userEntity: UserEntity, avatar: UIImage) {
        //        SVProgressHUD.show()
        //        if let image = self.avtImageView.image {
        //            let userEntity = UserEntity(fullName: self.fullNameTextField.text,
        //                                        nickname: self.residentIdTextField.text,
        //                                        dateOfBirth: self.currentDate.formatDate(),
        //                                        phoneNumber: self.nativePlaceTextField.text,
        //                                        gender: self.genderLabel.text ?? "",
        //                                        avtURL: "",
        //                                        favoriteHotels: [])
        //            UserDatabase.shared.addNewUser(email: email,
        //                                       password: password,
        //                                       userEntity: userEntity,
        //                                       image: image,
        //                                       completion: { error in
        //                SVProgressHUD.dismiss()
        //                if let error = error {
        //                    FailedDialog.show(title: "Failed to sign up new account",
        //                                      message: error.localizedDescription)
        //                } else {
        //                    let notificationView = NotificationDialogView.loadView()
        //                    notificationView.delegate = self
        //                    notificationView.show(in: self.view,
        //                                          title: "Sign up successfully!",
        //                                          message: "Welcome to Helia Hotel Booking App. Let's try it right now")
        //                }
        //            })
        //        }
        let userEntityWithPhoneNumber = UserEntity(fullName: userEntity.fullName,
                                                   residentId: userEntity.residentId,
                                                   dateOfBirth: userEntity.dateOfBirth,
                                                   phoneNumber: self.phoneNumber,
                                                   nativePlace: userEntity.nativePlace,
                                                   gender: userEntity.gender,
                                                   avtURL: userEntity.avtURL,
                                                   password: self.password)
        SVProgressHUD.show()
        UserDatabase.shared.addNewUser(userEntity: userEntityWithPhoneNumber,
                                       image: avatar) { error in
            SVProgressHUD.dismiss()
            if error != nil {
                self.router?.bindSignUpResultToFillProfile(isSuccess: false)
            } else {
                self.router?.bindSignUpResultToFillProfile(isSuccess: true)
            }
        }
    }
}
