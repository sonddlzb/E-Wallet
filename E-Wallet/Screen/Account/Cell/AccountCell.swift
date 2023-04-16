//
//  AccountCell.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import UIKit

class AccountCell: UICollectionViewCell {

    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    func bind(itemViewModel: AccountItemViewModel) {
        self.imageView.image = itemViewModel.image()
        self.numberLabel.text = itemViewModel.cardNumber()
    }
}
