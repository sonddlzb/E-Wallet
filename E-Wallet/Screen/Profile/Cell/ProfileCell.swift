//
//  ProfileCell.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import UIKit

class ProfileCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(profileOption: ProfileOption) {
        self.nameLabel.text = profileOption.name()
        self.imageView.image = profileOption.image()
    }
}
