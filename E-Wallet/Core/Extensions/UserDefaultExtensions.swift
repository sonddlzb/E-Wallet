//
//  UserDefaultExtensions.swift
//  KiteVid
//
//  Created by Thanh Vu on 22/04/2021.
//  Copyright © 2021 Thanh Vu. All rights reserved.
//

import Foundation

private struct UserDefaultsConst {
    static let launchCountKey = "launchCount"
}

public extension UserDefaults {
    func increaseLaunchCount() {
        let count = self.integer(forKey: UserDefaultsConst.launchCountKey)
        self.setValue(count + 1, forKey: UserDefaultsConst.launchCountKey)
    }

    func launchCount() -> Int {
        return self.integer(forKey: UserDefaultsConst.launchCountKey)
    }
}
