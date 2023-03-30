//
//  HomeTabBarView.swift
//  TestCustomView
//
//  Created by đào sơn on 03/03/2023.
//

import Foundation

import UIKit

protocol HomeTabBarDelegate: AnyObject {
    func homeTabBar(_ homeTabBar: HomeTabBar, didSelect homeTab: HomeTab)
}

class HomeTabBar: UIView {
    // MARK: - Variables
    var currentTab: HomeTab {
        return self.currentTabPrivate
    }

    // MARK: - Private variables
    private var currentTabPrivate: HomeTab = .home {
        didSet {
            if oldValue != currentTabPrivate {
                reloadContentView()
            }
        }
    }

    private var stackView: UIStackView!
    weak var delegate: HomeTabBarDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.configStackView()
        self.addAllSubviewsForStackView()
        self.reloadContentView()
    }

    // MARK: - Config
    private func configStackView() {
        self.stackView = UIStackView()
        self.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.fitSuperviewConstraint()
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
    }

    private func addAllSubviewsForStackView() {
        guard self.stackView.subviews.first == nil else {
            return
        }

        for homeTab in HomeTab.allCases {
            let memberView = HomeTabBarItemView()
            memberView.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(memberView)
            memberView.bind(homeTab: homeTab, isFocus: homeTab == self.currentTab)
            memberView.addTarget(self, action: #selector(didSelectTabBarItem(_:)), for: .touchUpInside)
        }
    }

    @objc func didSelectTabBarItem(_ sender: HomeTabBarItemView) {
        self.currentTabPrivate = sender.homeTab
        delegate?.homeTabBar(self, didSelect: sender.homeTab)
    }

    private func reloadContentView() {
        self.stackView.subviews.forEach({ view in
            if let itemView = view as? HomeTabBarItemView {
                itemView.isFocus = itemView.homeTab == self.currentTabPrivate
            }
        })
    }

    // MARK: - Public function
    func setSelectedTab(_ tab: HomeTab) {
        self.currentTabPrivate = tab
    }
}
