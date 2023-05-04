//
//  VoucherCell.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import UIKit

class VoucherCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var expirationTimeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    func bind(itemViewModel: GiftItemViewModel) {
        self.imageView.image = itemViewModel.image()
        self.descriptionLabel.text = itemViewModel.description()
        self.expirationTimeLabel.text = itemViewModel.expirationDate()
    }

    @IBAction func didTapUseNoew(_ sender: Any) {
        // handle use voucher
    }
}
