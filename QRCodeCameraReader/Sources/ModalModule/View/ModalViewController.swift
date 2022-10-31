//
//  ModalViewController.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.
//

import UIKit
import WebKit
import SnapKit

class ModalViewController: UIViewController, WKUIDelegate {
    
    var webView = WKWebView()
    var link: Model?
    let manager = DataManager()
    
    var presenter: ModalPresenter?
    
    lazy var shareButton: UIButton = {
        let shareButton = UIButton(type: .system)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        shareButton.tintColor = .black
        return shareButton
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        webView.tintColor = .black
        activityIndicator.startAnimating()
        webView.load(manager.requestToLoad!)
        activityIndicator.stopAnimating()
    }
    
    private func setupHierarchy() {
        view.addSubview(topView)
        topView.addSubview(shareButton)
        topView.addSubview(closeButton)
        view.addSubview(webView)
        view.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(50)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.size.equalTo(40)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
            make.left.equalTo(view.snp.left).offset(20)
            make.size.equalTo(40)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.size.equalTo(100)
        }
    }
}


extension ModalViewController: ModalViewProtocol {
    
    @objc func shareAction() {
        presenter?.saveFile()
    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
}
