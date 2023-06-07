//
//  NotificationCell.swift
//  E-Wallet
//
//  Created by đào sơn on 02/06/2023.
//

import UIKit

class NotificationCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func bind(itemViewModel: NotificationsItemViewModel) {
        self.imageView.image = itemViewModel.image()
        self.messageLabel.text = itemViewModel.message()
        self.dateLabel.text = itemViewModel.date()
    }
}
