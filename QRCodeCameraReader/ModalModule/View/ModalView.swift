//
//  ModalView.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.
//

import UIKit
import WebKit
import SnapKit

class ModalView: UIView {
    
    // MARK: - Properties
    
    var webView = WKWebView()
    
    lazy var shareButton: UIButton = {
        let shareButton = UIButton(type: .system)
        shareButton.translatesAutoresizingMaskIntoConstraints = false

        shareButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        shareButton.tintColor = .black
        return shareButton
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        return closeButton
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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
        webView.tintColor = .black
        activityIndicator.startAnimating()
    }
    
    private func setupHierarchy() {
        addSubview(topView)
        topView.addSubview(shareButton)
        topView.addSubview(closeButton)
        addSubview(webView)
        addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        topView.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.height.equalTo(50)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.bottom.equalTo(snp.bottom)
        }
        
        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-20)
            make.size.equalTo(40)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
            make.left.equalTo(snp.left).offset(20)
            make.size.equalTo(40)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.size.equalTo(100)
        }
    }
}

