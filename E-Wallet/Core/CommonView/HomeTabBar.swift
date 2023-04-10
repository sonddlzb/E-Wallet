//
//  HomeTabBar.swift
//
//  Created by đào sơn on 07/09/2022.
//

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
    private var currentTabPrivate: HomeTab = .dashboard {
        didSet {
            if oldValue != currentTabPrivate {
                reloadContentView()
            }
        }
    }

    private var stackView: UIStackView!
    weak var delegate: HomeTabBarDelegate?

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
        self.addTopShadow()
        self.reloadContentView()
    }

    private func addTopShadow() {
        self.layer.shadowColor = UIColor.crayola.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4.0
        self.clipsToBounds = false
    }

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
            let containerView = HomeItemTabBarView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(containerView)
            containerView.bind(homeTab: homeTab, isFocus: homeTab == self.currentTab)
            containerView.addTarget(self, action: #selector(didSelectTabBarItem(_:)), for: .touchUpInside)
        }
    }

    @objc func didSelectTabBarItem(_ sender: HomeItemTabBarView) {
        if sender.homeTab.canHighlighted() {
            self.currentTabPrivate = sender.homeTab
            self.reloadContentView()
        }

        delegate?.homeTabBar(self, didSelect: sender.homeTab)
    }

    private func reloadContentView() {
        self.stackView.subviews.forEach({ view in
            if let itemView = view as? HomeItemTabBarView {
                itemView.isFocus = itemView.homeTab == self.currentTabPrivate
            }
        })
    }

    // MARK: - Public function
    func setSelectedTab(_ tab: HomeTab) {
        if !tab.canHighlighted() {
            return
        }

        self.currentTabPrivate = tab
    }
}
