//
//  ConfirmDataCell.swift
//  E-Wallet
//
//  Created by đào sơn on 19/04/2023.
//

import UIKit

class ConfirmDataCell: UICollectionViewCell {

    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(itemViewModel: TransactionConfirmItemViewModel) {
        self.keyLabel.text = itemViewModel.key
        self.valueLabel.text = itemViewModel.value
    }
}
