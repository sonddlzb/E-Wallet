//
//  ScannerViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 11/05/2023.
//

import RIBs
import RxSwift
import UIKit
import AVFoundation

protocol ScannerPresentableListener: AnyObject {
    func handleQRScanningResult(text: String)
}

final class ScannerViewController: UIViewController, ScannerPresentable, ScannerViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var qrView: UIView!

    // MARK: - Variables
    weak var listener: ScannerPresentableListener?
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var imagePicker = UIImagePickerController()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    private func config() {
        self.imagePicker.delegate = self

        captureSession = AVCaptureSession()
        PermissionHelper().requestCameraPermission(mediaType: .video) { [weak self] granted, needOpenSetting in
            if granted {
                DispatchQueue.main.async {
                    self?.handleScanner()
                }
            } else if needOpenSetting {
                let openSettingDialog = NotificationDialogView.loadView()
                openSettingDialog.delegate = self
                openSettingDialog.show(in: self?.view ?? UIView(),
                                       title: "No camera permission",
                                       message: "E-Wallet want to access your camera",
                                       image: UIImage(named: "ic_stand"),
                                       color: .crayola,
                                       okTitle: "Open Setting")
            }
        }
    }

    func handleScanner() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("Can not add input to capture session.")
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Can not add output to capture session.")
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.qrView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.qrView.layer.addSublayer(previewLayer)

        self.captureSession.startRunning()
    }

    // MARK: - Actions
    @IBAction func didTapOpenGalleryButton(_ sender: Any) {
        self.openGallery()
    }

    // MARK: - Helpers

    func openGallery() {
        PermissionHelper().requestPhotoPermission { granted, needOpenSetting in
            if granted {
                DispatchQueue.main.async {
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else if needOpenSetting {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        }
    }

    func scanQRCodeFromImage(image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            print("Can not create CIImage from image.")
            return
        }

        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: ciImage)

        if let qrCodeFeature = features?.first as? CIQRCodeFeature {
            if let qrCodeContent = qrCodeFeature.messageString {
                // Xử lý dữ liệu từ mã QR ở đây
                print("QR content: \(qrCodeContent)")
                self.listener?.handleQRScanningResult(text: qrCodeContent)
            }
        } else {
            print("QR not found from image!")
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }

            print("QR content: \(stringValue)")
            self.listener?.handleQRScanningResult(text: stringValue)

            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - NotificationDialogViewDelegate
extension ScannerViewController: NotificationDialogViewDelegate {
    func notificationDialogViewDidTapOk(_ notificationDialogView: NotificationDialogView) {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ScannerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            self.scanQRCodeFromImage(image: pickedImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
