//
//  CustomPageControl.swift
//  HeliaHotelBooking
//
//  Created by Hà Quang Hưng on 02/03/2023.
//

import UIKit

private struct PageSlideBarConst {
    static var iconNotFocusSize: Double = 5.0
    static var iconFocusSize: Double = 16.0
}

class PageSlideBar: UIStackView {
    var numberOfPages = 3 {
        didSet {
            self.removeAllSubviews()
            self.addAllSubviews()
        }
    }

    var currentPage = 0 {
        didSet {
            self.oldCurrentPage = oldValue
            reloadCurrentPage()
        }
    }

    var mainColor: UIColor = UIColor(rgb: 0x28c96c) {
        didSet {
            self.removeAllSubviews()
            self.addAllSubviews()
        }
    }

    private var oldCurrentPage = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.axis = .horizontal
        self.spacing = 5.0
        self.reloadCurrentPage()
    }

    private func addAllSubviews() {
        guard self.subviews.isEmpty else {
            return
        }

        for index in 0...numberOfPages - 1 {
            let containerView = UIView()
            containerView.backgroundColor = self.mainColor
            containerView.alpha = index == currentPage ? 1 : 0.3
            containerView.cornerRadius = PageSlideBarConst.iconNotFocusSize/2
            containerView.translatesAutoresizingMaskIntoConstraints = false

            self.addArrangedSubview(containerView)
            containerView.widthAnchor.constraint(equalToConstant: index == currentPage ? PageSlideBarConst.iconFocusSize : PageSlideBarConst.iconNotFocusSize).isActive = true
        }
    }

    private func reloadCurrentPage() {
        guard !self.arrangedSubviews.isEmpty else {
            return
        }

        if oldCurrentPage == currentPage {
            return
        }

        let oldCurrentView = self.arrangedSubviews[self.oldCurrentPage]
        let newCurrentView = self.arrangedSubviews[self.currentPage]
        UIView.animate(withDuration: 0.25, animations: {
            oldCurrentView.widthConstraint()?.constant = PageSlideBarConst.iconNotFocusSize
            newCurrentView.widthConstraint()?.constant = PageSlideBarConst.iconFocusSize
            oldCurrentView.alpha = 0.3
            newCurrentView.alpha = 1
            self.layoutIfNeeded()
        })
    }

    private func removeAllSubviews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
}
