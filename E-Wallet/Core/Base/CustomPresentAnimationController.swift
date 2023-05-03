//
//  CustomPresentAnimationController.swift
//  E-Wallet
//
//  Created by đào sơn on 19/04/2023.
//

import UIKit

class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView

        toViewController.view.frame = CGRect(x: 0, y: containerView.frame.height, width: containerView.frame.width, height: containerView.frame.height/4*3)
        containerView.addSubview(toViewController.view)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.frame = CGRect(x: 0, y: containerView.frame.height/4, width: containerView.frame.width, height: containerView.frame.height/4*3)
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
