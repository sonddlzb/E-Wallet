//
//  PhotoPreviewViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 08/07/2023.
//

import RIBs
import RxSwift
import UIKit

protocol PhotoPreviewPresentableListener: AnyObject {
    func didTapCancel()
}

final class PhotoPreviewViewController: UIViewController, PhotoPreviewViewControllable {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Variables
    weak var listener: PhotoPreviewPresentableListener?

    @IBAction func didTapCancel(_ sender: Any) {
        self.listener?.didTapCancel()
    }

    @IBAction func didTapDownload(_ sender: Any) {
        PermissionHelper().requestPhotoPermission { granted, needOpenSetting in
            if granted {
                if let image = self.imageView.image {
                    UIImageWriteToSavedPhotosAlbum(image,
                                                   self,
                                                   #selector(self.image(_:didFinishSavingWithError:contextInfo:)),
                                                   nil)
                }
            } else if needOpenSetting {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
         if let error = error {
             self.view.makeToast(error.localizedDescription)
         } else {
             self.view.makeToast("Save image successfully!")
         }
     }
}

// MARK: - PhotoPreviewPresentable
extension PhotoPreviewViewController: PhotoPreviewPresentable {
    func bind(viewModel: PhotoPreviewViewModel) {
        self.loadViewIfNeeded()
        self.imageView.image = viewModel.image
    }
}
    