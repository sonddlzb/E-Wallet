//
//  FailedDialog.swift
//  ColoringByPixel
//
//  Created by đào sơn on 12/09/2022.
//

import UIKit

final class FailedDialog: UIView {

    static var shared = FailedDialog()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_wrong")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.cornerRadius = 12.0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var confirmButton: TapableView = {
        let confirmButton = TapableView()
        confirmButton.backgroundColor = UIColor(rgb: 0xF8D568)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.cornerRadius = 20.0
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        return confirmButton
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Error"
        titleLabel.numberOfLines = 0
        titleLabel.font = Outfit.semiBoldFont(size: 20)
        titleLabel.textColor = UIColor(rgb: 0x242124)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "Something went wrong, please try again later"
        messageLabel.numberOfLines = 2
        messageLabel.font = Outfit.regularFont(size: 14)
        messageLabel.textColor = UIColor(rgb: 0x615F5F)
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()

    private lazy var confirmLabel: UILabel = {
        let confirmLabel = UILabel()
        confirmLabel.textColor = UIColor(rgb: 0x242124)
        confirmLabel.text = "Confirm"
        confirmLabel.font = Outfit.mediumFont(size: 16)
        confirmLabel.textAlignment = .center
        confirmLabel.translatesAutoresizingMaskIntoConstraints = false
        return confirmLabel
    }()

    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.config()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.cornerRadius = 24.0
        self.backgroundColor = .black.withAlphaComponent(0.7)
        self.addContentView()
        self.setUpConstraints()
    }

    private func addContentView() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(imageView)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(messageLabel)
        self.containerView.addSubview(self.confirmButton)
        self.confirmButton.addSubview(confirmLabel)
    }

    private func setUpConstraints() {
        self.confirmLabel.fitSuperviewConstraint()

        NSLayoutConstraint.activate([

            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 250.0),

            self.imageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 24),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 56),
            self.imageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 15),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.messageLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8.0),
            self.messageLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 18),
            self.messageLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -18),

            self.confirmButton.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 21.0),
            self.confirmButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.confirmButton.widthAnchor.constraint(equalToConstant: 106.0),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }

    @objc private func confirmButtonDidTap() {
        self.dismiss()
    }

    // MARK: - Helper
    private func dismiss() {
        guard self.superview != nil else {
            return
        }

        UIView.animate(withDuration: 0.15) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    // MARK: - Static function
    static func show(title: String, message: String) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              shared.superview == nil else {
            return
        }

        shared.alpha = 0
        window.addSubview(shared)
        shared.fitSuperviewConstraint()
        shared.titleLabel.text = title
        shared.messageLabel.text = message

        UIView.animate(withDuration: 0.15) {
            shared.alpha = 1
        }
    }

    static func dismiss() {
        shared.dismiss()
    }

    // MARK: - Touches
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss()
    }
}
