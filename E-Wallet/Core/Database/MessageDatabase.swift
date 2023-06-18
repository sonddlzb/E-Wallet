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

    func getListRecentMessages(completion: @escaping (_ recentMessagesDict: [User: Message]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion([:])
            return
        }

        self.messageRef.child(userId).observe(.value) { dataSnapshot in
            var listRecentMessages: [Message] = []
            var userDict: [String: Date] = [:]
            if let listMessagesDict = dataSnapshot.value as? NSDictionary {
                for key in listMessagesDict.allKeys {
                    if let messageDict = listMessagesDict.object(forKey: key) as? NSDictionary {
                        let messageEntity = MessageEntity(dict: messageDict)
                        let messageObject = Message(id: key as? String ?? "", entity: messageEntity)
                        if let newestDate = userDict[messageObject.id] {
                            if newestDate < messageObject.sendTime {
                                listRecentMessages.append(messageObject)
                                userDict[messageObject.id] = messageObject.sendTime
                            }
                        } else {
                            listRecentMessages.append(messageObject)
                            userDict[messageObject.id] = messageObject.sendTime
                        }
                    }
                }
            }

            listRecentMessages = listRecentMessages.sorted {
                $0.sendTime > $1.sendTime
            }

            var recentMessagesDict: [User: Message] = [:]
            for message in listRecentMessages {
                if message.receiverId == userId {
                    UserDatabase.shared.getUserBy(id: message.senderId) { userEntity in
                        if let userEntity = userEntity {
                            recentMessagesDict[User(id: message.senderId, entity: userEntity)] = message
                            if recentMessagesDict.count == listRecentMessages.count {
                                completion(recentMessagesDict)
                            }
                        }
                    }
                } else {
                    UserDatabase.shared.getUserBy(id: message.receiverId) { userEntity in
                        if let userEntity = userEntity {
                            recentMessagesDict[User(id: message.receiverId, entity: userEntity)] = message
                            if recentMessagesDict.count == listRecentMessages.count {
                                completion(recentMessagesDict)
                            }
                        }
                    }
                }
            }
        }
    }
}
