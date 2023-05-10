//
//  GiftApplyCell.swift
//  E-Wallet
//
//  Created by đào sơn on 10/05/2023.
//

import UIKit

protocol GiftApplyCellDelegate: AnyObject {
    func giftApplyCell(_ giftApplyCell: GiftApplyCell, didSelectDetailsAt voucher: Voucher)
}

class GiftApplyCell: UICollectionViewCell {

    @IBOutlet private weak var expiredLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var selectedView: UIView!

    weak var delegate: GiftApplyCellDelegate?
    private var itemViewModel: GiftApplyItemViewModel!

    func bind(itemViewModel: GiftApplyItemViewModel, isSelected: Bool) {
        self.itemViewModel = itemViewModel
        self.descriptionLabel.text = itemViewModel.description()
        self.expiredLabel.text = itemViewModel.expirationDate()
        self.imageView.image = itemViewModel.image()
        self.selectedView.isHidden = !isSelected
        self.borderColor = isSelected ? .crayola : UIColor(rgb: 0xE5E5EA)
    }
    @IBAction func didTapDetailsButton(_ sender: Any) {
        self.delegate?.giftApplyCell(self, didSelectDetailsAt: itemViewModel.voucher)
    }
}
