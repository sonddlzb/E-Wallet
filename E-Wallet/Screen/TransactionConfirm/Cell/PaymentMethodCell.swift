//
//  PaymentMethodCell.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import UIKit

class PaymentMethodCell: UICollectionViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(itemViewModel: CardItemViewModel, isSelected: Bool, isFullVersion: Bool) {
        self.imageView.image = itemViewModel.image()
        self.nameLabel.text = isFullVersion ? itemViewModel.cardNumber() : itemViewModel.name()
        self.nameLabel.font = isFullVersion ? Outfit.semiBoldFont(size: 20.0) : Outfit.semiBoldFont(size: 14.0)
        self.messageLabel.text = "Free"
        self.messageLabel.font = isFullVersion ? Outfit.lightFont(size: 14.0) : Outfit.lightFont(size: 12.0)
        self.borderColor = isSelected ? .crayola : .systemGray5
        self.containerView.backgroundColor = isSelected ? UIColor.crayola.withAlphaComponent(0.1) : .white
    }

    func bind(balance: Double, isSelected: Bool, isFullVersion: Bool) {
        self.imageView.image = UIImage(named: "ic_wallet")
        self.nameLabel.text = "E-Wallet"
        self.messageLabel.text = "$" + String(balance)
        self.borderColor = isSelected ? .crayola : .systemGray5
        self.containerView.backgroundColor = isSelected ? UIColor.crayola.withAlphaComponent(0.1) : .white

        self.nameLabel.font = isFullVersion ? Outfit.semiBoldFont(size: 20.0) : Outfit.semiBoldFont(size: 14.0)
        self.messageLabel.font = isFullVersion ? Outfit.lightFont(size: 14.0) : Outfit.lightFont(size: 12.0)
    }

    func bindAddCell(isFullVersion: Bool) {
        self.imageView.image = UIImage(named: "ic_plus_crayola")
        self.nameLabel.text = "Add bank"
        self.messageLabel.text = "Direct payment"
        self.borderColor = .systemGray5
        self.containerView.backgroundColor = .white

        self.nameLabel.font = isFullVersion ? Outfit.semiBoldFont(size: 20.0) : Outfit.semiBoldFont(size: 14.0)
        self.messageLabel.font = isFullVersion ? Outfit.lightFont(size: 14.0) : Outfit.lightFont(size: 12.0)
    }
}
