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
    func routeToTransfer()
    func routeToTopUp()
}

final class DashboardViewController: UIViewController, DashboardViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var optionViewTopConstraintLayout: NSLayoutConstraint!
    @IBOutlet private weak var centerPriceLabel: UILabel!
    @IBOutlet private weak var centerLabelContainerView: UIView!
    @IBOutlet private weak var topPriceLabel: UILabel!
    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var dashBoardBarView: DashboardBarView!

    // MARK: - Variables
    weak var listener: DashboardPresentableListener?
    private var homeViewModel: HomeViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.contentView.setupCornerRadius(topLeftRadius: 32.0, topRightRadius: 32.0, bottomLeftRadius: 0.0, bottomRightRadius: 0.0)
        topPriceLabel.isHidden = true
        self.dashBoardBarView.delegate = self
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

// MARK: - DashboardPresentable
extension DashboardViewController: DashboardPresentable {
    func bind(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.loadViewIfNeeded()
        self.topPriceLabel.text = homeViewModel.currency() + " " + String(homeViewModel.balance())
        self.centerPriceLabel.text = homeViewModel.currency() + " " + String(homeViewModel.balance())
        self.welcomeLabel.text = "Welcome " + homeViewModel.name()
    }
}

// MARK: - DashboardBarViewDelegate
extension DashboardViewController: DashboardBarViewDelegate {
    func dashboardBarView(_ dashboardBarView: DashboardBarView, didSelectAt dashboardOption: DashboardOption) {
        switch dashboardOption {
        case .transfer:
            self.listener?.routeToTransfer()
        case .topUp:
            self.listener?.routeToTopUp()
        case .withdraw:
            print("Did select withdraw")
        case .qrScan:
            print("Did select qrscan")
        }
    }
}
