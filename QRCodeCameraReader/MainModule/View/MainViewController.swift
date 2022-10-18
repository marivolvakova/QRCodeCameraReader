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
    
    //var presenter: MainPresenter?
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    let output = AVCaptureMetadataOutput()
    var outputObject: AVMetadataMachineReadableCodeObject?
    var link: String?

    private var mainView: MainView? {
        guard isViewLoaded else { return nil }
        return view as? MainView
    }
    
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCameraSettings()
        
        mainView?.scanButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func startCameraSettings() {
        setupInput()
        setupOutput()
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = (view?.layer.bounds)!
    }
    
    func setupInput() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found") }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            print(error)
            return
        }
    }
    
    func setupOutput() {
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        captureSession.addOutput(output)
    }
    
    @objc func buttonTapped() {
        view.layer.addSublayer(videoPreviewLayer)
        captureSession.startRunning()
    }
}

extension MainViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            mainView?.qrCodeFrameView.frame = CGRect.zero
            mainView?.messageLabel.text = "No QR code is detected"
            return
        }
        
        if metadataObjects.count > 0 {
            if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: object)
                    mainView?.qrCodeFrameView.frame = barCodeObject!.bounds
                    view.bringSubviewToFront(mainView!.qrCodeFrameView)
                    
                    mainView?.messageLabel.text = "\(String(describing: object.stringValue ?? ""))"
                    self.present(ModalViewController(), animated: true)
                }
            }
            
        } else {
            mainView?.qrCodeFrameView.frame = CGRect.zero
            mainView?.messageLabel.text = "No QR code is detected"
        }
    }
}

