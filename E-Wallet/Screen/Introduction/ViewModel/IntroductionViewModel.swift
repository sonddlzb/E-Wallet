//
//  IntroductionViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import Foundation
import UIKit

struct IntroductionViewModel {
    var listTitles = ["Add all accounts & manage",
                      "Track your activity",
                      "Send & request payments"]
    var listMessages = ["You can add all accounts in one place and use it to send and request.",
                        "You can track your income, expenses activities and all statistics.",
                        "You can send or recieve any payments from yous accounts."]
    var currentPageIndex = 0

    func item(at index: Int) -> IntroductionItemViewModel {
        return IntroductionItemViewModel(title: self.listTitles[index],
                                         message: self.listMessages[index],
                                         image: UIImage(named: "slide\(index)"),
                                         index: index)
    }

    func numberOfSlides() -> Int {
        return self.listTitles.count
    }
}
