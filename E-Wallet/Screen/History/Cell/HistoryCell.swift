//
//  HistoryCell.swift
//  E-Wallet
//
//  Created by đào sơn on 25/04/2023.
//

import UIKit

class HistoryCell: UICollectionViewCell {

    @IBOutlet private weak var imageViewContainer: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageViewContainer.layer.cornerRadius = self.imageViewContainer.frame.height/2
    }

    func bind(itemViewModel: HistoryItemViewModel) {
        self.descriptionLabel.text = itemViewModel.description()
        self.timeLabel.text = itemViewModel.time()
        self.imageView.image = itemViewModel.image()
        self.amountLabel.text = itemViewModel.amount()
        self.statusImageView.image = UIImage(named: itemViewModel.transaction.status == .completed ? "ic_success" : "ic_wrong")
    }
}
