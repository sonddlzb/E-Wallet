//
//  ChatDetailsInteractor+PhotoPreview.swift
//  E-Wallet
//
//  Created by đào sơn on 08/07/2023.
//

import Foundation

extension ChatDetailsInteractor: PhotoPreviewListener {
    func photoPreviewWantToDismiss() {
        self.router?.dismissPhotoPreview()
    }
}
