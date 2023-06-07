//
//  NotificationDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 29/05/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UIKit

class NotificationDatabase {
    private var notificationRef = Database.database().reference().child(DatabaseConst.notificationPath)
    static var shared = NotificationDatabase()

    func addNewNotification(receiverId: String, notificationEntity: NotificationMessageEntity) {
        self.notificationRef.child(receiverId).childByAutoId().setValue(notificationEntity.dict) { error, _ in
            if let error = error {
                print("Failed to add new notification: \(error)")
            }
        }
    }

    func subscribeNotification(completion: @escaping (_ message: NotificationMessage?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        self.notificationRef.child(userId).observe(.childAdded) { dataSnapshot in
            if let message = dataSnapshot.value as? [String: Any] {
                completion(NotificationMessage(dict: message))
            }
        }
    }

    func fetchAllNotification(completion: @escaping (_ listNotifications: [NotificationMessage]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        self.notificationRef.child(userId).getData { error, data in
            guard error == nil, let data = data else {
                completion([])
                return
            }

            var listNotifications: [NotificationMessage] = []
            if let notifications = data.value as? NSDictionary {
                for dict in notifications.allValues.compactMap {$0 as? [String: Any] } {
                    listNotifications.append(NotificationMessage(dict: dict))
                }
            }

            completion(listNotifications)
        }
    }
}
