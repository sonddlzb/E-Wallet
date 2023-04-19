//
//  UIViewControllerExtensions.swift
//
//  Created by Thanh Vu on 12/02/2021.
//  Copyright © 2020 thanhvu. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    func topVC() -> UIViewController {
        if let navigation = self as? UINavigationController, !navigation.viewControllers.isEmpty {
            return navigation.topViewController!.topVC()
        }

        if let presentedVC = self.presentedViewController {
            return presentedVC.topVC()
        }

        return self
    }

    func popTo<T>(_ viewController: T.Type) {
        let targetVC = navigationController?.viewControllers.filter {$0 is T}.first
        if let targetVC = targetVC {
            navigationController?.popToViewController(targetVC, animated: true)
        }
    }

    func presentCustomViewController(_ viewController: UIViewController) {
        let customPresentTransitioningDelegate = CustomPresentTransitioningDelegate()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = customPresentTransitioningDelegate
        present(viewController, animated: true, completion: nil)
    }

    func dismissCustomViewController() {
        dismiss(animated: true, completion: nil)
    }
}
