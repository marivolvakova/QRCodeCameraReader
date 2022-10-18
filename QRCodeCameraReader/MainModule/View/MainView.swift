//
//  MainView.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    // MARK: - Properties
    
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
        messageLabel.font = .systemFont(ofSize: 40, weight: .semibold)
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
        messageLabel.textAlignment = .center
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
        return scanButton
    }()
    
    // MARK: - Initial
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    // MARK: - Settings
    
    func setupView() {
        backgroundColor = .white
    }
    
    func setupHierarchy() {
        addSubview(messageLabel)
        addSubview(scanButton)
        addSubview(qrCodeFrameView)
        addSubview(codeLabel)
    }
    
    func setupLayout() {
        codeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(snp.top).offset(150)
        }
        scanButton.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.height.equalTo(65)
            make.width.equalTo(150)
        }
        messageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(snp.bottom).offset(-40)
            make.centerX.equalTo(snp.centerX)
        }
    }
}
