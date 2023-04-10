//
//  DashboardBarItemView.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import UIKit

class DashboardBarItemView: TapableView {
    var dashboardOption: DashboardOption!

    private var nameLabel: UILabel!
    private var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func bind(dashboardOption: DashboardOption) {
        self.dashboardOption = dashboardOption
        self.refreshContentView()
    }

    func refreshContentView() {
        self.subviews.forEach({
            $0.removeFromSuperview()
        })

        self.imageView = UIImageView()
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.image = self.dashboardOption.image()

        self.nameLabel = UILabel()
        self.nameLabel.font = Outfit.mediumFont(size: 16.0)
        self.nameLabel.textColor = .black
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        self.nameLabel.text = self.dashboardOption.name()

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
