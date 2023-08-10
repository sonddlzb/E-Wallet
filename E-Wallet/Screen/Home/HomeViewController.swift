//
//  HomeViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs
import RxSwift
import UIKit
import NotificationBannerSwift

protocol HomePresentableListener: AnyObject {
    func homeTabBarItemDidSelect(didSelect homeTab: HomeTab)
    func reloadCurrentTabData()
    func didSelectNotification()
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
//        let entity = VoucherEntity(description: "Discount 20% max $8 for all types of bill",
//                                   discountType: "percent",
//                                   openTime: Date(timeIntervalSinceReferenceDate: 705302560.84386),
//                                   amount: 20, expirationTime: Date(timeIntervalSinceReferenceDate: 718502560.84386),
//                                   minValue: 30,
//                                   maxDiscount: 8,
//                                   userId: "2udUU4cluNVF46jE2QL0val6k892",
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

    func routeToDashboard() {
        self.homeTabBar.setSelectedTab(.dashboard)
    }
}

// MARK: - HomePresentable
extension HomeViewController: HomePresentable {
    func selectHistoryTab() {
        self.homeTabBar.setSelectedTab(.history)
    }

    func selectChatTab() {
        self.homeTabBar.setSelectedTab(.chat)
    }

    func showNotification(message: NotificationMessage) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let banner = FloatingNotificationBanner(title: message.title, subtitle: message.message, style: .success)
            banner.onTap = { [weak self] in
                self?.listener?.didSelectNotification()
            }

            banner.show(cornerRadius: 9, shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1), shadowBlurRadius: 8, shadowEdgeInsets: UIEdgeInsets(top: 4, left: 4, bottom: 0, right: 4))
        })
    }
}
