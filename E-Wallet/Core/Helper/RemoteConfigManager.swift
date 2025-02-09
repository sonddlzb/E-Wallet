//
//  RemoteConfigManager.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import Foundation
import FirebaseRemoteConfig

private struct Const {
    static let expirationDuration = 0.0
}

class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    private var remoteConfig = RemoteConfig.remoteConfig()

    func configRemoteConfigDefaults() {
        let defaultValues = FirebaseConst.defaultFValues
        remoteConfig.setDefaults(defaultValues as [String: NSObject])
    }

    func fetchValue(key: String, completion: @escaping (_ value: RemoteConfigValue?) -> Void) {
        remoteConfig.fetch(withExpirationDuration: Const.expirationDuration) { [weak self] (status, error) -> Void in
            if status == .success {
                self?.remoteConfig.activate { _, _ in
                    let remoteValue = self?.remoteConfig.configValue(forKey: key)
                    completion(remoteValue)
                }
            } else {
                print("Lỗi khi tải giá trị cấu hình từ Firebase: \(error?.localizedDescription ?? "")")
                let defaultValue = self?.remoteConfig.defaultValue(forKey: key)
                completion(defaultValue)
            }
        }
    }
}
