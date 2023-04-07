//
//  UserDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit

class UserDatabase {
    private var database = Firestore.firestore()
    static var shared = UserDatabase()

    func addNewUser(userEntity: UserEntity,
                    image: UIImage,
                    completion: @escaping (_ error: Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        self.uploadAvatar(name: userId, image: image) { url, error in
            guard let url = url else {
                completion(error)
                return
            }

            let userEntityWithURL = UserEntity(fullName: userEntity.fullName,
                                               residentId: userEntity.residentId,
                                               dateOfBirth: userEntity.dateOfBirth,
                                               phoneNumber: userEntity.phoneNumber,
                                               nativePlace: userEntity.nativePlace,
                                               gender: userEntity.gender,
                                               avtURL: url,
                                               password: userEntity.password)
            guard let userData = try? JSONSerialization
                .jsonObject(with: JSONEncoder()
                    .encode(userEntityWithURL)) as? [String: Any] else {
                print("Failed to convert entity to dictionary!")
                return
            }

            self.database.collection(DatabaseConst.usersCollectionName).document(userId).setData(userData)
            completion(nil)
        }
    }

    func uploadAvatar(name: String, image: UIImage, completion: @escaping (_ url: String?, _ error: Error?) -> Void) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(DatabaseConst.avatarPath + "/\(name).png")
        if let uploadData = image.pngData() {
            fileRef.putData(uploadData) { _, error in
                if let error = error {
                    print("Error when uploading data \(error)")
                    completion(nil, error)
                } else {
                    fileRef.downloadURL { url, error in
                        guard let url = url, error == nil else {
                            print("Failed to get avatar url")
                            completion(nil, error)
                            return
                        }

                        print("Upload file to \(url.absoluteString)")
                        completion(url.absoluteString, nil)
                        guard let userId = Auth.auth().currentUser?.uid else {
                            return
                        }

                        self.database.collection(DatabaseConst.usersCollectionName).document(userId)
                        .updateData(["avtURL": url.absoluteString]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                        }
                    }
                }
            }
        }
    }

    func checkPassword(password: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        self.database.collection(DatabaseConst.usersCollectionName).document(userId).getDocument { document, err in
            if let err = err {
                print("Error get documents: \(err)")
                completion(false)
            } else if let document = document {
                guard let userData = try? JSONSerialization.data(withJSONObject: document.data() ?? [:],
                                                                 options: []) else {
                    completion(false)
                    return
                }

                if let userEntity = try? JSONDecoder().decode(UserEntity.self, from: userData) {
                    completion(userEntity.password == password)
                }
            }
        }
    }
}
