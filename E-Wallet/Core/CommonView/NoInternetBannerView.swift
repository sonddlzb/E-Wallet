//
//  NoInternetBanner.swift
//  commonUI
//
//  Created by đào sơn on 09/09/2022.
//

import UIKit

private struct NoInternetBannerViewConst {
    static let bottomContentConstant: CGFloat = -77
}

class NoInternetBannerView: SkippedInteractiveView {

    static var shared = NoInternetBannerView()

    public static func show(duration: Double = -1) {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}),
              shared.superview == nil else {
            return
        }

        window.addSubview(shared)
        shared.fitSuperviewConstraint()
        shared.layoutIfNeeded()

        shared.startShowingAnimation()
    }

    // MARK: - Variable
    private let duration: Double = -1
    private var bottomConstraintLayout: NSLayoutConstraint!

    private lazy var bundle: Bundle = { .main }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.cornerRadius = 8
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Outfit.mediumFont(size: 14)
        label.textColor = UIColor(rgb: 0x212121)
        label.numberOfLines = 0
        label.text = "God bless you"
        label.textAlignment = .left
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = Outfit.regularFont(size: 11)
        label.textColor = UIColor(rgb: 0x8B8B8B)
        label.numberOfLines = 0
        label.text = "Please check your internet connection and try again."
        label.textAlignment = .left
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_no_internet", in: bundle)
        return imageView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.config()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.config()
    }

    // MARK: - Config
    private func config() {
        configBasicUI()
        addContentView()
        self.setUpConstraints()
    }

    private func addContentView() {
        containerView.addSubview(imageView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(titleLabel)
        self.addSubview(containerView)
    }

    private func setUpConstraints() {
        self.bottomConstraintLayout = containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 200)
        self.bottomConstraintLayout.isActive = true

        let activeConstraints: [NSLayoutConstraint] = [
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28),
            imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
            imageView.rightAnchor.constraint(equalTo: messageLabel.leftAnchor, constant: -16),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 13),
            titleLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -3),

            messageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14)
        ]

        NSLayoutConstraint.activate(activeConstraints)
    }

    private func configBasicUI() {
        containerView.backgroundColor = UIColor(rgb: 0xFCEDE9)
        containerView.layer.borderWidth = 1.6
        containerView.borderColor = UIColor(rgb: 0xFC4040)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Animation
    private func startShowingAnimation() {
        UIView.animate(withDuration: 0.15, animations: {
            self.bottomConstraintLayout.constant = NoInternetBannerViewConst.bottomContentConstant
            self.layoutIfNeeded()
        }, completion: nil)

        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if duration >= 0 {
            self.perform(#selector(dismiss), with: self, afterDelay: duration)
        }
    }

    public static func dismiss() {
        shared.dismiss()
    }

    @objc private func dismiss() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        UIView.animate(withDuration: 0.15, animations: {
            self.bottomConstraintLayout.constant = 200
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
