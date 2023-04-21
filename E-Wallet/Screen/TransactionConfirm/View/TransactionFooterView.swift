//
//  TransactionFooterView.swift
//  E-Wallet
//
//  Created by đào sơn on 20/04/2023.
//

import UIKit

class TransactionFooterView: UICollectionReusableView {
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var discountSymbolLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(amount: Double, discount: Double) {
        if discount > 0.0 {
            self.discountLabel.text = String(discount).formatMoney()
            self.discountSymbolLabel.isHidden = false
        } else {
            self.discountSymbolLabel.isHidden = true
        }

        self.totalLabel.text = String(amount - discount).formatMoney()
    }
}
