//
//  MessageAudioDatabase.swift
//  E-Wallet
//
//  Created by đào sơn on 11/07/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit

class MessageAudioDatabase {
    let messageAudioRef = Storage.storage().reference(withPath: "audio")
    static let shared = MessageAudioDatabase()

    func sendAudio(_ audioURL: URL, receiverId: String, repliedId: String, completion: @escaping (_ error: Error?, _ isSuccess: Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let fileRef = messageAudioRef.child(userId).child(String(Date().timeIntervalSinceReferenceDate) + ".m4a")
        fileRef.putFile(from: audioURL) { _, error in
            if let error = error {
                print("Get error when sending audio \(error.localizedDescription)")
                completion(error, false)
            } else {
                fileRef.downloadURL { url, error in
                    guard error == nil, let url = url else {
                        print("get sent audio url failed \(error?.localizedDescription)")
                        completion(error, false)
                        return
                    }

                    let sendTime = Date()
                    let messageSendEntity = MessageEntity(content: "", status: MessageStatus.sent.rawValue, type: MessageType.audio.rawValue, mediaLink: url.absoluteString, sendTime: sendTime, repliedId: repliedId)
                    let messageReceiveEntity = MessageEntity(content: "", status: MessageStatus.received.rawValue, type: MessageType.audio.rawValue, mediaLink: url.absoluteString, sendTime: sendTime, repliedId: repliedId)

                    MessageDatabase.shared.sendMessage(senderId: userId, receiverId: receiverId, sendEntity: messageSendEntity, receiveEntity: messageReceiveEntity) { isSuccess in
                        completion(nil, isSuccess)
                    }
                }
            }
        }
    }
}
