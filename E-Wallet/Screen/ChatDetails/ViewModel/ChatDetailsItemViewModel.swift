//
//  ChatDetailsItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import Foundation
import FirebaseAuth

struct ChatDetailsItemViewModel {
    var message: Message

    func content() -> String {
        return message.content
    }

    func amount() -> String {
        return String(message.amount)
    }

    func transactionId() -> String {
        return message.transactionId
    }

    func mediaURL() -> URL? {
        return URL(string: self.message.mediaLink)
    }

    func scale() -> Double? {
        if message.height != 0, message.width != 0 {
            return message.width/message.height
        } else {
            return nil
        }
    }

    func downloadM4AFile(completion: @escaping(_ audioURL: URL?) -> Void) {
        guard let url = self.mediaURL(), let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        let request = URLRequest(url: url)
        let rootPath = FileManager.default.currentDirectoryPath
        let path = URL(fileURLWithPath: rootPath + (message.senderId == userId ? message.receiverId : message.senderId) + "/" + UUID().uuidString)

        let task = session.downloadTask(with: request) { (localURL, _, error) in
            if let error = error {
                print("Error downloading file: \(error)")
                completion(nil)
            } else if let localURL = localURL {
                completion(localURL)
            }
        }

        task.resume()
    }
}
