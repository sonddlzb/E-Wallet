//
//  SlideCell.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import UIKit

protocol SlideCellDelegate: AnyObject {
    func slideCellDidTapSkip(_ slideCell: SlideCell)
}

class SlideCell: UICollectionViewCell {
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var skipButton: TapableView!

    weak var delegate: SlideCellDelegate?

    func bind(itemViewModel: IntroductionItemViewModel) {
        self.messageLabel.text = itemViewModel.message
        self.titleLabel.text = itemViewModel.title
        self.imageView.image = itemViewModel.image
        self.skipButton.isHidden = itemViewModel.index == 2
    }
    
    @IBAction func skipButtonDidTap(_ sender: Any) {
        self.delegate?.slideCellDidTapSkip(self)
    }
}
