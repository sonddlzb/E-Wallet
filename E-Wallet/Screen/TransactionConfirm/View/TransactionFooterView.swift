//
//  TransactionFooterView.swift
//  E-Wallet
//
//  Created by đào sơn on 20/04/2023.
//

import UIKit

protocol TransactionFooterViewDelagate: AnyObject {
    func transactionFooterViewDidSelectDiscount(_ transactionFooterView: TransactionFooterView)
    func transactionFooterViewDidSelectCancel(_ transactionFooterView: TransactionFooterView)
}

class TransactionFooterView: UICollectionReusableView {
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var discountSymbolLabel: UILabel!
    @IBOutlet weak var discountDescriptionLabel: UILabel!
    @IBOutlet weak var promotionView: UIView!

    weak var delegate: TransactionFooterViewDelagate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(amount: Double, discount: Double) {
        if discount > 0.0 {
            self.discountLabel.text = String(discount).formatMoney()
            self.discountSymbolLabel.isHidden = false
            self.promotionView.isHidden = false
        } else {
            self.discountSymbolLabel.isHidden = true
            self.promotionView.isHidden = true
        }

        self.totalLabel.text = String(amount - discount).formatMoney()
    }

    @IBAction func didTapSelectDiscountButton(_ sender: Any) {
        self.delegate?.transactionFooterViewDidSelectDiscount(self)
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.promotionView.isHidden = true
        self.discountSymbolLabel.isHidden = true
        self.discountLabel.text = ""
        self.delegate?.transactionFooterViewDidSelectCancel(self)
    }

    func bind(voucher: Voucher) {
        self.discountDescriptionLabel.text = voucher.description
    }
}
