//
//  ChatCell.swift
//  E-Wallet
//
//  Created by đào sơn on 12/06/2023.
//

import UIKit

class ChatCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var recentLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.layer.cornerRadius = self.imageView.frame.height/2
    }

    func bind(itemViewModel: ChatItemViewModel) {
        self.imageView.setImage(with: itemViewModel.avatarURL(), indicator: .activity)
        self.nameLabel.text = itemViewModel.name()
        self.dateLabel.text = itemViewModel.recentTime()

        switch itemViewModel.newestMessage.type {
        case .text: self.recentLabel.text = itemViewModel.recentMessage()
        case .sendMoney: self.recentLabel.text = "Transfer money"
        case .audio: self.recentLabel.text = "Audio"
        case .image: self.recentLabel.text = "Image"
        }
    }
}
