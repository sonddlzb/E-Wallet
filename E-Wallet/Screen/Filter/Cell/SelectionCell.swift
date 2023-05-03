//
//  SelectionCell.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import UIKit

class SelectionCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!

    func bind(itemViewModel: FilterSelectionItemViewModel, isSelect: Bool) {
        self.nameLabel.text = itemViewModel.selection
        self.containerView.borderColor = isSelect ? .crayola : UIColor(rgb: 0xD1D1D6)
    }
}
