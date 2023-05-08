//
//  VoucherCell.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import UIKit

protocol VoucherCellDelegate: AnyObject {
    func voucherCellDidTapUseNow(_ voucherCell: VoucherCell, itemViewModel: GiftItemViewModel)
}

class VoucherCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var expirationTimeLabel: UILabel!
    @IBOutlet weak var useNowLabel: UILabel!
    @IBOutlet weak var useNowButton: TapableView!
    @IBOutlet weak var imageView: UIImageView!

    weak var delegate: VoucherCellDelegate?
    private var itemViewModel: GiftItemViewModel!

    func bind(itemViewModel: GiftItemViewModel) {
        self.itemViewModel = itemViewModel
        self.imageView.image = itemViewModel.image()
        self.descriptionLabel.text = itemViewModel.description()
        self.expirationTimeLabel.text = itemViewModel.expirationDate()
        self.useNowLabel.textColor = itemViewModel.isReadyToUse() ? .crayola : .darkGray
    }

    @IBAction func didTapUseNow(_ sender: Any) {
        self.delegate?.voucherCellDidTapUseNow(self, itemViewModel: self.itemViewModel)
    }
}
