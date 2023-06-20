//
//  MoneyMessageSendCell.swift
//  E-Wallet
//
//  Created by đào sơn on 20/06/2023.
//

import UIKit

protocol MoneyMessageSendCellDelegate: AnyObject {
    func didTapToSeeSendDetails(transactionId: String)
}

class MoneyMessageSendCell: UICollectionViewCell {

    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var moneyLabel: UILabel!

    weak var delegate: MoneyMessageSendCellDelegate?
    var itemViewModel: ChatDetailsItemViewModel?

    override func layoutSubviews() {
        super.layoutSubviews()
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.shadowOpacity = 0.5
        self.containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.containerView.layer.shadowRadius = 4
        self.containerView.layer.masksToBounds = false
    }

    func bind(itemViewModel: ChatDetailsItemViewModel) {
        self.itemViewModel = itemViewModel
        self.moneyLabel.text = "$" + itemViewModel.amount()
    }

    @IBAction func didTapToSeeDetails(_ sender: Any) {
        guard let transactionId = self.itemViewModel?.transactionId(), !transactionId.isEmpty else {
            return
        }

        self.delegate?.didTapToSeeSendDetails(transactionId: transactionId)
    }
}
