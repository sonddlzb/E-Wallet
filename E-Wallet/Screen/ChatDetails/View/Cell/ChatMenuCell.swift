//
//  ChatMenuCell.swift
//  E-Wallet
//
//  Created by đào sơn on 27/06/2023.
//

import UIKit

class ChatMenuCell: UICollectionViewCell {

    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.borderView.layer.cornerRadius = self.borderView.bounds.height/2
        self.borderView.borderWidth = 1
        self.borderView.borderColor = .lightGray
    }

    func bind(itemViewModel: ChatMenuItemViewModel) {
        self.imageView.image = itemViewModel.image()
        self.nameLabel.text = itemViewModel.name()
    }
}
