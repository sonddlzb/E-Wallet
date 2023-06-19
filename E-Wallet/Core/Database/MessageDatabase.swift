//
//  MessageDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 13/06/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UIKit

class MessageDatabase {
    private var messageRef = Database.database().reference().child(DatabaseConst.messagePath)
    static var shared = MessageDatabase()

    func getListRecentTalkers(completion: @escaping (_ listRecentTalkers: [User]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        self.messageRef.child(userId).observe(.value) { dataSnapshot in
            var listRecentTalkers: [User] = []
            if let listUsersDict = dataSnapshot.value as? NSDictionary {
                for userId in listUsersDict.allKeys {
                    if let userId = userId as? String {
                        UserDatabase.shared.getUserBy(id: userId) { userEntity in
                            if let userEntity = userEntity {
                                listRecentTalkers.append(User(id: userId, entity: userEntity))
                                if listRecentTalkers.count == listUsersDict.count {
                                    completion(listRecentTalkers)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func getNewestMessageOf(talker: User, completion: @escaping (_ message: Message?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        self.messageRef.child(userId).child(talker.id).getData { error, dataSnapshot in
            guard error == nil, let dataSnapshot = dataSnapshot else {
                completion(nil)
                return
            }

            var newestMessage: Message?
            if let talkerDict = dataSnapshot.value as? NSDictionary {
                if let messagesDict = talkerDict[talker.id] as? NSDictionary {
                    for key in messagesDict.allKeys {
                        if let messageId = key as? String {
                            if let messageDict = messagesDict.object(forKey: key) as? NSDictionary {
                                let messageEntity = MessageEntity(dict: messageDict)
                                var senderId = ""
                                var receiverId = ""
                                if messageEntity.type == "sent" || messageEntity.type == "sentAndSeen" {
                                    senderId = userId
                                    receiverId = talker.id
                                } else {
                                    senderId = talker.id
                                    receiverId = userId
                                }

                                let messageObject = Message(id: messageId, senderId: senderId, receiverId: receiverId, entity: messageEntity)
                                if newestMessage != nil {
                                    if newestMessage!.sendTime.timeIntervalSinceReferenceDate < messageObject.sendTime.timeIntervalSinceReferenceDate {
                                        newestMessage = messageObject
                                        }
                                } else {
                                    newestMessage = messageObject
                                }
                            }
                        }
                    }
                }
            }

            completion(newestMessage)
        }
    }

    func getListRecentMessages(completion: @escaping (_ recentMessagesDict: [User: Message]) -> Void) {
        var recentMessagesDict: [User: Message] = [:]
        self.getListRecentTalkers { listTalkers in
            for talker in listTalkers {
                self.getNewestMessageOf(talker: talker) { message in
                    if let message = message {
                        recentMessagesDict[talker] = message
                        if recentMessagesDict.count == listTalkers.count {
                            completion(recentMessagesDict)
                        }
                    }
                }
            }
        }
    }
}
