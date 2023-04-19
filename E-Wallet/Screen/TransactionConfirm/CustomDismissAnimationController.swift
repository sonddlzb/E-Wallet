//
//  CustomDismissAnimationController.swift
//  E-Wallet
//
//  Created by đào sơn on 19/04/2023.
//

import UIKit

class CustomDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = CGRect(x: 0, y: containerView.frame.height, width: containerView.frame.width, height: containerView.frame.height/2)
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
