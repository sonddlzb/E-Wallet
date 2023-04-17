//
//  CardDetailsItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import Foundation

struct CardDetailsItemViewModel {
    var key: String

    func fetchValue(completion: @escaping (_ value: Double) -> Void) {
        RemoteConfigManager.shared.fetchValue(key: self.key) { value in
            if let value = value?.numberValue as? Double {
                completion(value)
            }
        }
    }

    func keyName() -> String {
        return self.key.replacingOccurrences(of: "_", with: " ").capitalized
    }
}
