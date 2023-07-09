//
//  MessageImageDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 05/07/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit

class MessageImageDatabase {
    let messageImageRef = Storage.storage().reference(withPath: "message")
    static let shared = MessageImageDatabase()

    func sendMessageImage(_ image: UIImage, receiverId: String, repliedId: String, completion: @escaping (_ error: Error?, _ isSuccess: Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let fileRef = messageImageRef.child(userId).child(String(Date().timeIntervalSinceReferenceDate) + ".png")
        if let uploadData = image.pngData() {
            fileRef.putData(uploadData) { _, error in
                if let error = error {
                    print("Get error when sending message \(error.localizedDescription)")
                    completion(error, false)
                } else {
                    fileRef.downloadURL { url, error in
                        guard error == nil, let url = url else {
                            print("get sent image url failed \(error?.localizedDescription)")
                            completion(error, false)
                            return
                        }

                        let sendTime = Date()
                        let messageSendEntity = MessageEntity(content: "", status: MessageStatus.sent.rawValue, type: MessageType.image.rawValue, mediaLink: url.absoluteString, sendTime: sendTime, repliedId: repliedId, width: image.size.width, height: image.size.height)
                        let messageReceiveEntity = MessageEntity(content: "", status: MessageStatus.received.rawValue, type: MessageType.image.rawValue, mediaLink: url.absoluteString, sendTime: sendTime, repliedId: repliedId, width: image.size.width, height: image.size.height)
                        
                        MessageDatabase.shared.sendMessage(senderId: userId, receiverId: receiverId, sendEntity: messageSendEntity, receiveEntity: messageReceiveEntity) { isSuccess in
                            completion(nil, isSuccess)
                        }
                    }
                }
            }
        }
    }
}
