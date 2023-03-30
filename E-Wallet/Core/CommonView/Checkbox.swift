//
//  Checkbox.swift
//  HeliaHotelBooking
//
//  Created by Hà Quang Hưng on 10/03/2023.
//

import UIKit

class CheckBox: UIButton {
    let checkedImage: UIImage? = .ic_bookmark_selected
    let uncheckedImage: UIImage? = .ic_bookmark_black

    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        isChecked = !isChecked
    }
}
