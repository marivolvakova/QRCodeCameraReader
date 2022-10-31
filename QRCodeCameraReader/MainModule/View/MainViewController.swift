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
    
    var presenter: MainPresenter?
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    lazy var qrCodeFrameView: UIView = {
        let qrCodeFrameView = UIView()
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 6
        return qrCodeFrameView
    }()
    
    lazy var codeLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .black
        messageLabel.font = .systemFont(ofSize: 35, weight: .semibold)
        messageLabel.backgroundColor = .white
        messageLabel.text = "QR CODE SCAN"
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .black
        messageLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        messageLabel.backgroundColor = .white
        messageLabel.text = "Direct the camera at the QR code"
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    lazy var scanButton: UIButton = {
        let scanButton = UIButton(type: .system)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        scanButton.setTitle("Push to start", for: .normal)
        scanButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        scanButton.backgroundColor = .blue
        scanButton.tintColor = .white
        scanButton.layer.masksToBounds = true
        scanButton.layer.cornerRadius = 10
        scanButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return scanButton
    }()
    
    @objc func buttonTapped() {
        view.layer.addSublayer(videoPreviewLayer)
        captureSession.startRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupView()
        scannerSettings()
    }
    
    func scannerSettings() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found") }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            print(error)
            return
        }
        
        let output = AVCaptureMetadataOutput()
        captureSession.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.layer.bounds
    }
    
    // MARK: - Setup functions
    
    func setupView() {
        view.backgroundColor = .white
        videoPreviewLayer.frame = view.layer.bounds
    }
    
    func setupHierarchy() {
        view.addSubview(messageLabel)
        view.addSubview(scanButton)
        view.addSubview(codeLabel)
        view.addSubview(qrCodeFrameView)
    }
    
    func setupLayout() {
        codeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(150)
        }
        scanButton.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.height.equalTo(65)
            make.width.equalTo(150)
        }
        messageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-40)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}

extension MainViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        switch metadataObjects.count {
        case 1...:
            if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr  {
                    let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: object)
                    qrCodeFrameView.frame = barCodeObject!.bounds
                    view.bringSubviewToFront(qrCodeFrameView)
                    messageLabel.text = "\(String(describing: object.stringValue ?? ""))"
                    presenter?.showModalView(with: object.stringValue ?? "")
                }
            }
        default:
            qrCodeFrameView.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
        }
    }
}
