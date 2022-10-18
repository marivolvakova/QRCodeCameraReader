//
//  MainViewController.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.
//

import UIKit
import SnapKit
import AVFoundation

class MainViewController: UIViewController {
    
    // MARK: - Properties

    var presenter: MainViewPresenterProtocol!
    
    var captureSession = AVCaptureSession()
    let output = AVCaptureMetadataOutput()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    private var mainView: MainView? {
        guard isViewLoaded else { return nil }
        return view as? MainView
    }
    
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scannerSettings()
        mainView?.scanButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func scannerSettings() {
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        captureSession.addInput(presenter.input!)
        captureSession.addOutput(output)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.layer.bounds
    }
    
    @objc func buttonTapped() {
        view.layer.addSublayer(videoPreviewLayer)
        captureSession.startRunning()
    }
}

extension MainViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        switch metadataObjects.count {
        case 0:
            mainView?.qrCodeFrameView.frame = CGRect.zero
            mainView?.messageLabel.text = "No QR code is detected"
            
        default:
            if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: object)
                    mainView?.qrCodeFrameView.frame = barCodeObject!.bounds
                    mainView?.bringSubviewToFront(mainView!.qrCodeFrameView)
                    
                    mainView?.messageLabel.text = "\(String(describing: object.stringValue ?? ""))"
                    
                    self.present(ModalViewController(), animated: true)
                }
            }
        }
    }
}

