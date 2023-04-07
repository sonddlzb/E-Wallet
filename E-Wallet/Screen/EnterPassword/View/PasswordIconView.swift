//
//  PasswordIconView.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import UIKit

class PasswordIconView: UIView {
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()

    var numberOfIcons = 6 {
        didSet {
            self.setUpView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }

    private func setUpView() {
        self.addContentViews()
        self.addLayoutConstraints()
    }

    private func addContentViews() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.stackView)
        for _ in 1...numberOfIcons {
            let iconView = UIView()
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.borderColor = .black
            iconView.borderWidth = 2
            iconView.cornerRadius = 8
            self.stackView.addArrangedSubview(iconView)
        }
    }

    private func addLayoutConstraints() {
        self.containerView.fitSuperviewConstraint()
        self.stackView.fitSuperviewConstraint()
    }

    func select(at position: Int) {
        guard position >= 0, position < self.numberOfIcons else {
            return
        }

        for (index, subview) in stackView.subviews.enumerated() {
            if index == position {
                subview.backgroundColor = .black
            }
        }
    }

    func delete(at position: Int) {
        guard position >= 0, position < self.numberOfIcons else {
            return
        }

        for (index, subview) in stackView.subviews.enumerated() {
            if index == position {
                subview.backgroundColor = .white
            }
        }
    }

    func reset() {
        stackView.subviews.forEach {
            $0.backgroundColor = .white
        }
    }
}
