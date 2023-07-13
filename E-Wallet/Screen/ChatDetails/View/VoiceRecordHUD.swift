//
//  VoiceRecordHUD.swift
//  E-Wallet
//
//  Created by đào sơn on 09/07/2023.
//

import UIKit

@IBDesignable
class VoiceRecordHUD: UIView {
    var rate: CGFloat = 0.0

    var fillColor: UIColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }

    var image: UIImage! {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage(named: "ic_recording")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        image = UIImage(named: "ic_recording")
    }

    func update(_ rate: CGFloat) {
        self.rate = rate
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: bounds.size.height)
        context?.scaleBy(x: 1, y: -1)

        context?.draw(image.cgImage!, in: bounds)
        context?.clip(to: bounds, mask: image.cgImage!)

        context?.setFillColor(fillColor.cgColor.components!)
        context?.fill(CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * rate))
    }

    override func prepareForInterfaceBuilder() {
        let bundle = Bundle(for: type(of: self))
        image = UIImage(named: "ic_recording", in: bundle, compatibleWith: self.traitCollection)
    }
}
