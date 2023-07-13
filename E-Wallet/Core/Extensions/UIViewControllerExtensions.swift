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

    func presentCustomViewController(_ viewController: UIViewController, rate: Double = 0.75) {
        let customPresentTransitioningDelegate = CustomPresentTransitioningDelegate()
        customPresentTransitioningDelegate.rate = rate
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = customPresentTransitioningDelegate
        present(viewController, animated: true, completion: nil)
    }

    func dismissCustomViewController() {
        dismiss(animated: true, completion: nil)
    }

    func showToast(message: String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-100, width: self.view.frame.size.width-40, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0, options: .curveLinear, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
