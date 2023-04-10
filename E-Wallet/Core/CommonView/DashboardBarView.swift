//
//  DashboardBarView.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import UIKit

protocol DashboardBarViewDelegate: AnyObject {
    func dashboardBarView(_ dashboardBarView: DashboardBarView, didSelectAt: DashboardOption)
}

class DashboardBarView: UIView {

    private var stackView: UIStackView!
    weak var delegate: DashboardBarViewDelegate?

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
    }

    private func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4.0
        self.clipsToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.addShadow()
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

        for dashboardOption in DashboardOption.allCases {
            let containerView = DashboardBarItemView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(containerView)
            containerView.bind(dashboardOption: dashboardOption)
            containerView.addTarget(self, action: #selector(didSelectDashboardBarItem(_:)), for: .touchUpInside)
        }
    }

    @objc func didSelectDashboardBarItem(_ sender: DashboardBarItemView) {
        delegate?.dashboardBarView(self, didSelectAt: sender.dashboardOption)
    }
}
