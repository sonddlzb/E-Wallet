//
//  HomeItemTabBarView.swift
//  commonUI
//
//  Created by đào sơn on 08/09/2022.
//

import UIKit

private struct HomeItemTabBarViewConst {
    static var curvedHeight = 6.0
    static let nameSize: CGFloat = 11
}

class HomeItemTabBarView: TapableView {
    var homeTab: HomeTab!
    var isFocus = false {
        didSet {
            self.reloadContentView()
        }
    }

    private var imageViewTopConstraint: NSLayoutConstraint!
    private var curveImageViewTopConstraint: NSLayoutConstraint!
    private var nameLabel: UILabel!
    private var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func bind(homeTab: HomeTab, isFocus: Bool) {
        self.homeTab = homeTab
        self.isFocus = isFocus
        self.refreshContentView()
    }

    func refreshContentView() {
        self.subviews.forEach({
            $0.removeFromSuperview()
        })

        let curveImageView = UIImageView()
        if let url = Bundle.main.url(forResource: "curvedImage", withExtension: "png") {
            curveImageView.image = UIImage(contentsOfFile: url.path)
        }

        curveImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(curveImageView)

        self.imageView = UIImageView()
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.image = self.homeTab.getItemImage(isFocus: self.isFocus)

        self.nameLabel = UILabel()
        self.nameLabel.font = Outfit.regularFont(size: HomeItemTabBarViewConst.nameSize)
        self.nameLabel.textColor = .mediumGray
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        self.nameLabel.text = self.homeTab.getItemName()

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            curveImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            curveImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            curveImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3)
        ])

        self.imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0)
        self.curveImageViewTopConstraint = curveImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: homeTab == .dashboard ? HomeItemTabBarViewConst.curvedHeight : 0)
        self.imageViewTopConstraint.isActive = true
        self.curveImageViewTopConstraint.isActive = true
    }

    func reloadContentView() {
        guard !self.subviews.isEmpty,
              !(self.isFocus && !self.homeTab.canHighlighted()) else {
            return
        }

        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.imageView.image = self.homeTab.getItemImage(isFocus: self.isFocus)
            self.nameLabel.textColor = self.isFocus ? .crayola : .mediumGray 
            self.nameLabel.font = self.isFocus ? Outfit.mediumFont(size: HomeItemTabBarViewConst.nameSize) : Outfit.regularFont(size: HomeItemTabBarViewConst.nameSize)
            self.imageViewTopConstraint.constant = self.isFocus ? 3.0 : 10.0
            self.curveImageViewTopConstraint.constant = self.isFocus ? -HomeItemTabBarViewConst.curvedHeight : 0
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
