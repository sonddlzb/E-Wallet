//
//  ImageMessageReceiveCell.swift
//  E-Wallet
//
//  Created by đào sơn on 03/07/2023.
//

import UIKit

protocol ImageMessageReceiveCellDelegate: AnyObject {
    func imageMessageReceiveCell(_ imageMessageReceiveCell: ImageMessageReceiveCell, didSelect image: UIImage)
}

class ImageMessageReceiveCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    weak var delegate: ImageMessageReceiveCellDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.containerView.layer.cornerRadius = 10.0
    }

    func bind(itemViewModel: ChatDetailsItemViewModel) {
        self.imageView.setImage(with: itemViewModel.mediaURL(), indicator: .activity)
        if let scale = itemViewModel.scale() {
            self.widthConstraint.constant = (self.frame.height - 20.0) * scale
        }
    }

    @IBAction func didTapImage(_ sender: Any) {
        if let image = self.imageView.image {
            self.delegate?.imageMessageReceiveCell(self, didSelect: image)
        }
    }
}

