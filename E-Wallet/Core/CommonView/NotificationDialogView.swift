//
//  NotificationDialogView.swift
//  TestCustomView
//
//  Created by đào sơn on 02/03/2023.
//

import UIKit

protocol NotificationDialogViewDelegate: AnyObject {
    func notificationDialogViewDidTapOk(_ notificationDialogView: NotificationDialogView)
}

class NotificationDialogView: UIView {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet weak var mesageImage: UIImageView!

    // MARK: - ConstraintLayout
    @IBOutlet weak var mesageLeadingSuperViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mesageTrailingSuperViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mesageTopSuperViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mesageBottomTitleLabelTopConstraint: NSLayoutConstraint!
    
    
    static func loadView() -> NotificationDialogView {
        return NotificationDialogView.loadView(fromNib: "NotificationDialogView") ?? NotificationDialogView()
    }

    weak var delegate: NotificationDialogViewDelegate?

    // MARK: - Public method
    func show(in view: UIView) {
        self.alpha = 0
        view.addSubview(self)
        self.fitSuperviewConstraint()
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    func show(in view: UIView, title: String, message: String) {
        self.alpha = 0
        self.titleLabel.text = title
        self.messageLabel.text = message
        view.addSubview(self)
        self.fitSuperviewConstraint()
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    func show(in view: UIView, title: String, message: String, image: UIImage?) {
        self.alpha = 0
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.mesageImage.image = image
        view.addSubview(self)
        self.fitSuperviewConstraint()
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    // MARK: - Touches began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view == self.backgroundView {
            self.dismiss()
        }
    }

    @IBAction func okButtonDidTap(_ sender: TapableView) {
        self.delegate?.notificationDialogViewDidTapOk(self)
        self.dismiss()
    }
}
