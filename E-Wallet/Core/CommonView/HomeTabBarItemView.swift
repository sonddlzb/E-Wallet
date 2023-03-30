//
//  HomeTabBarItemView.swift
//  TestCustomView
//
//  Created by đào sơn on 03/03/2023.
//

import UIKit
class HomeTabBarItemView: TapableView {

    // MARK: - Outlets
    private var nameLabel: UILabel!
    private var imageView: UIImageView!

    // MARK: - Variables
    var homeTab: HomeTab = .home
    var isFocus = false {
        didSet {
            self.reloadContentView()
        }
    }

    // MARK: - Binding
    func bind(homeTab: HomeTab, isFocus: Bool) {
        self.homeTab = homeTab
        self.isFocus = isFocus
        self.refreshContentView()
    }

    private func reloadContentView() {
        guard !self.subviews.isEmpty else {
            return
        }

        self.imageView.image = self.homeTab.getItemImage(isFocus: self.isFocus)
        self.nameLabel.textColor = UIColor(rgb: self.isFocus ? 0x1BB65C : 0xD2D2D2)
        self.nameLabel.font = self.isFocus ? Outfit.mediumFont(size: 12) : Outfit.regularFont(size: 12)
    }

    private func refreshContentView() {
        self.subviews.forEach({
            $0.removeFromSuperview()
        })

        self.imageView = UIImageView()
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.image = self.homeTab.getItemImage(isFocus: self.isFocus)
        self.imageView.contentMode = .scaleAspectFill

        self.nameLabel = UILabel()
        self.nameLabel.font = Outfit.regularFont(size: 12)
        self.nameLabel.textColor = .lotion
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        self.nameLabel.text = self.homeTab.getItemName()

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.nameLabel.topAnchor, constant: -5.0)
        ])
    }
}
