//
//  UserDefaultExtensions.swift
//  KiteVid
//
//  Created by Thanh Vu on 22/04/2021.
//  Copyright © 2021 Thanh Vu. All rights reserved.
//

import Foundation
import FirebaseAuth

private struct UserDefaultsConst {
    static let launchCountKey = "launchCount"
    static let validatePassword = "validatePassword"
}

public extension UserDefaults {
    func increaseLaunchCount() {
        let count = self.integer(forKey: UserDefaultsConst.launchCountKey)
        self.setValue(count + 1, forKey: UserDefaultsConst.launchCountKey)
    }

    func launchCount() -> Int {
        return self.integer(forKey: UserDefaultsConst.launchCountKey)
    }

    func isValidatePassword() -> Bool {
        if let userId = Auth.auth().currentUser?.uid {
            return self.bool(forKey: UserDefaultsConst.validatePassword + userId)
        } else {
            return false
        }
    }

    func saveValidPasswordStatus() {
        if let userId = Auth.auth().currentUser?.uid {
            self.setValue(true, forKey: UserDefaultsConst.validatePassword + userId)
        }
    }

    func removeValidPasswordStatus() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        self.removeObject(forKey: UserDefaultsConst.validatePassword + userId)
    }
}
