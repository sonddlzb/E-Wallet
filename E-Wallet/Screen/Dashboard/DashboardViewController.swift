//
//  DashboardViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol DashboardPresentableListener: AnyObject {
}

final class DashboardViewController: UIViewController, DashboardPresentable, DashboardViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var optionViewTopConstraintLayout: NSLayoutConstraint!
    @IBOutlet private weak var centerPriceLabel: UILabel!
    @IBOutlet private weak var centerLabelContainerView: UIView!
    @IBOutlet private weak var topPriceLabel: UILabel!

    // MARK: - Variables
    weak var listener: DashboardPresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.contentView.setupCornerRadius(topLeftRadius: 32.0, topRightRadius: 32.0, bottomLeftRadius: 0.0, bottomRightRadius: 0.0)
        topPriceLabel.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contentView.setupCornerRadius(topLeftRadius: 32.0, topRightRadius: 32.0, bottomLeftRadius: 0.0, bottomRightRadius: 0.0)
    }

    // MARK: - Helpers
    func hideTopPrice() {
        UIView.animate(withDuration: 0.15, delay: 0.0, animations: {
            self.topPriceLabel.isHidden = true
            self.centerLabelContainerView.isHidden = false
            self.loadViewIfNeeded()
        })
    }

    func showTopPrice() {
        UIView.animate(withDuration: 0.15, delay: 0.0, animations: {
            self.topPriceLabel.isHidden = false
            self.centerLabelContainerView.isHidden = true
            self.loadViewIfNeeded()
        })
    }
}

// MARK: - UIScrollViewDelegate
extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minValue = 0.0
        self.optionViewTopConstraintLayout.constant = max(80 - (scrollView.contentOffset.y), minValue)

        if scrollView.contentOffset.y > 30 {
            showTopPrice()
        } else {
            hideTopPrice()
        }
    }
}
