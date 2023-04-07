//
//  KeyCell.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import UIKit

class KeyCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height/2
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height/2
    }

    func bind(number: String) {
        self.numberLabel.text = number
        if number == "x" {
            self.numberLabel.textColor = .red
        } else {
            self.numberLabel.textColor = .black
        }
    }
}
