//
//  ServiceCell.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import UIKit

class ServiceCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    func bind(serviceType: ServiceType) {
        self.imageView.image = serviceType.image()
        self.nameLabel.text = serviceType.name()
    }
}
