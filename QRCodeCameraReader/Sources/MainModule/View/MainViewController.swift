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
    
    weak var presenter: MainPresenter?
    
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    private var qrCodeFrameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 6
        return view
    }()
    
    private var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 35, weight: .semibold)
        label.backgroundColor = .white
        label.text = "QR CODE SCAN"
        label.numberOfLines = 0
        return label
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.backgroundColor = .white
        label.text = "Direct the camera at the QR code"
        label.numberOfLines = 0
        return label
    }()
    
    private var scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Push to start", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupView()
        scannerSettings()
    }
    
    // MARK: - Setup functions
    
    private func setupView() {
        view.backgroundColor = .white
        videoPreviewLayer.frame = view.layer.bounds
        scanButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupHierarchy() {
        view.addSubview(messageLabel)
        view.addSubview(scanButton)
        view.addSubview(codeLabel)
        view.addSubview(qrCodeFrameView)
    }
    
    private func setupLayout() {
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
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension MainViewController: AVCaptureMetadataOutputObjectsDelegate {
    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        switch metadataObjects.count {
        case 1...:
            if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr  {
                    guard let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: object) else { return }
                    qrCodeFrameView.frame = barCodeObject.bounds
                    view.bringSubviewToFront(qrCodeFrameView)
                    guard let stringObject = object.stringValue else { return }
                    messageLabel.text = "\(stringObject)"
                    presenter?.showModalView(link: stringObject)
                }
            }
        default:
            qrCodeFrameView.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
        }
    }
}

// MARK: - MainViewProtocol Impl

extension MainViewController: MainViewProtocol {
    @objc func buttonTapped() {
        view.layer.addSublayer(videoPreviewLayer)
        captureSession.startRunning()
    }
}


