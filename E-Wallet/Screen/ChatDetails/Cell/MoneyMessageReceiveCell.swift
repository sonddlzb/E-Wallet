//
//  MoneyMessageReceiveCell.swift
//  E-Wallet
//
//  Created by đào sơn on 08/07/2023.
//

import UIKit

protocol MoneyMessageReceiveCellDelegate: AnyObject {
    func didTapToSeeReceiveDetails(transactionId: String)
}

class MoneyMessageReceiveCell: UICollectionViewCell {

    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var moneyLabel: UILabel!

    weak var delegate: MoneyMessageReceiveCellDelegate?
    var itemViewModel: ChatDetailsItemViewModel?

    override func layoutSubviews() {
        super.layoutSubviews()
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.imageView.transform = CGAffineTransform(scaleX: -1, y: -1)
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.shadowOpacity = 0.5
        self.containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.containerView.layer.shadowRadius = 4
        self.containerView.layer.masksToBounds = false
    }

    func bind(itemViewModel: ChatDetailsItemViewModel) {
        self.moneyLabel.text = "$" + itemViewModel.amount()
    }

    @IBAction func didTapToSeeDetails(_ sender: Any) {
        guard let transactionId = self.itemViewModel?.transactionId(), !transactionId.isEmpty else {
            return
        }

        self.delegate?.didTapToSeeReceiveDetails(transactionId: transactionId)
    }
}
