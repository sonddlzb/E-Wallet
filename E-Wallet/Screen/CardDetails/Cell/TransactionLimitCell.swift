//
//  TransactionLimitCell.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import UIKit

class TransactionLimitCell: UICollectionViewCell {
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var keyLabel: UILabel!

    func bind(itemViewModel: CardDetailsItemViewModel) {
        self.keyLabel.text = itemViewModel.keyName()
        itemViewModel.fetchValue { value in
            DispatchQueue.main.async {
                let isPercentage = itemViewModel.key == "withdraw_rate" || itemViewModel.key == "top_up_rate"
                self.valueLabel.text = isPercentage ? String(value).formatMoney() + "%" : "$" + String(value).formatMoney()
            }
        }
    }
}
