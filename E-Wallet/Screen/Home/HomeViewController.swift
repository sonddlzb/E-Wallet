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

final class HomeViewController: UIViewController, HomePresentable {

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
