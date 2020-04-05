//
//  AlertPresentationAnimator.swift
//  NativeUI
//
//  Created by Anton Poltoratskyi on 05.04.2020.
//  Copyright © 2020 Anton Poltoratskyi. All rights reserved.
//

import UIKit

final class AlertPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        if let alertViewController = fromViewController as? AlertViewController {
            animateHide(alertViewController, using: transitionContext)
            
        } else if let alertViewController = toViewController as? AlertViewController {
            animateShow(alertViewController, using: transitionContext)
        }
    }
    
    private func animateShow(_ alertViewController: AlertViewController, using transitionContext: UIViewControllerContextTransitioning) {
        guard let targetView = alertViewController.view else {
            return
        }
        transitionContext.containerView.addSubview(targetView)
        targetView.frame = transitionContext.containerView.bounds
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        let scale: CGFloat = 1.15
        let alertView = alertViewController.alertView
        alertView.transform = CGAffineTransform(scaleX: scale, y: scale)
        targetView.alpha = 0
        
        UIView.animate(withDuration: animationDuration, animations: {
            targetView.alpha = 1
            alertView.transform = .identity
            
        }, completion: { success in
            transitionContext.completeTransition(success)
        })
    }
    
    private func animateHide(_ alertViewController: AlertViewController, using transitionContext: UIViewControllerContextTransitioning) {
        guard let targetView = alertViewController.view else {
            return
        }
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        targetView.alpha = 1
        UIView.animate(withDuration: animationDuration, animations: {
            targetView.alpha = 0
            
        }, completion: { success in
            targetView.removeFromSuperview()
            transitionContext.completeTransition(success)
        })
    }
}
