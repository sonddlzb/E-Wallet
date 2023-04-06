//
//  SkippedInteractiveView.swift
//  CommonUI
//
//  Created by Linh Nguyen Duc on 30/12/2021.
//

import UIKit

class SkippedInteractiveView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitTest = super.hitTest(point, with: event)
        return hitTest == self ? nil : hitTest
    }
}
