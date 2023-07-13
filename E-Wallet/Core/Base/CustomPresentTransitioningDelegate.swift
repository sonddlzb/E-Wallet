//
//  CustomPresentTransitioningDelegate.swift
//  E-Wallet
//
//  Created by đào sơn on 19/04/2023.
//

import UIKit

class CustomPresentTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var rate = 0.75

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let customPresentAnimationController = CustomPresentAnimationController()
        customPresentAnimationController.rate = rate
        return customPresentAnimationController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let customDismissAnimationController = CustomDismissAnimationController()
        customDismissAnimationController.rate = rate
        return customDismissAnimationController
    }
}
