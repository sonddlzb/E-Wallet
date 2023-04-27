//
//  TopicTabBarViewCell.swift
//  TestCustomView
//
//  Created by đào sơn on 03/03/2023.
//

import UIKit

class TopicTabBarViewCell: UICollectionViewCell {

    @IBOutlet private weak var topicLabel: UILabel!

    func bind(topic: String, isSelected: Bool) {
        self.topicLabel.text = topic
        self.topicLabel.backgroundColor = isSelected ? .crayola : UIColor.white
        self.topicLabel.textColor = isSelected ? UIColor.white : .crayola
    }
}
