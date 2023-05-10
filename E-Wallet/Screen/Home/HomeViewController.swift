//
//  HomeViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol HomePresentableListener: AnyObject {
    func homeTabBarItemDidSelect(didSelect homeTab: HomeTab)
    func reloadCurrentTabData()
}

final class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var homeTabBar: HomeTabBar!

    // MARK: - Variables
    weak var listener: HomePresentableListener?
    private var currentViewController: ViewControllable?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeTabBar.delegate = self
    }

    // only for test add voucher
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let entity = VoucherEntity(description: "Discount 10% max $8 for all types of bill payment",
//                                   discountType: "percent",
//                                   openTime: Date(timeIntervalSinceReferenceDate: 703302560.84386),
//                                   amount: 10, expirationTime: Date(timeIntervalSinceReferenceDate: 708502560.84386),
//                                   minValue: 40,
//                                   maxDiscount: 8,
//                                   userId: "g7gpxnE9mLaL3JnIA6BDFpPPIXt1",
//                                   serviceTypes: ["Electricity", "Water", "Internet", "TV"])
//        VoucherDatabase.shared.createVoucher(voucherEntity: entity) { successfully in
//            print("add voucher \(successfully)")
//        }
//    }
}

// MARK: - HomeTabBarDelegate
extension HomeViewController: HomeTabBarDelegate {
    func homeTabBar(_ homeTabBar: HomeTabBar, didSelect homeTab: HomeTab) {
        self.listener?.homeTabBarItemDidSelect(didSelect: homeTab)
    }
}

// MARK: - HomeViewControllable
extension HomeViewController: HomeViewControllable {
    func highlightOnTabBar(tab: HomeTab) {
        if self.homeTabBar != nil {
            self.homeTabBar.setSelectedTab(tab)
        }
    }

    func embedViewController(_ viewController: ViewControllable) {
        self.loadViewIfNeeded()

        if self.currentViewController?.uiviewController == viewController.uiviewController {
            self.listener?.reloadCurrentTabData()
            return
        }

        self.currentViewController?.uiviewController.view.removeFromSuperview()
        self.currentViewController?.uiviewController.removeFromParent()

        self.contentView.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.fitSuperviewConstraint()

        self.addChild(viewController.uiviewController)
        self.currentViewController = viewController
    }
}

// MARK: - HomePresentable
extension HomeViewController: HomePresentable {
    func selectHistoryTab() {
        self.homeTabBar.setSelectedTab(.history)
    }
}
