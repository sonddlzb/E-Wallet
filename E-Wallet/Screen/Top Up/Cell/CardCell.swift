//
//  CardCell.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet private weak var selectedView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(itemViewModel: CardItemViewModel, isSelected: Bool) {
        self.imageView.image = itemViewModel.image()
        self.nameLabel.text = itemViewModel.cardNumber()
        self.selectedView.isHidden = !isSelected
        self.borderWidth = isSelected ? 2 : 0
    }

    func setUpAddCell() {
        self.imageView.image = UIImage(named: "ic_plus_crayola")
        self.nameLabel.text = "Add bank"
        self.selectedView.isHidden = true
        self.borderWidth = 0.0
    }
}
