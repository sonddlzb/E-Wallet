//
//  TextMessageReceiveCell.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import UIKit

class TextMessageReceiveCell: UICollectionViewCell {

    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var contentContainerView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    func bind(itemViewModel: ChatDetailsItemViewModel) {
        self.contentLabel.text = itemViewModel.content()
    }
}
