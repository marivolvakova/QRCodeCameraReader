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
    
    // MARK: - Properties
    
    private var webView = WKWebView()
    private var link: String?
    private let manager = DataManagerImpl()
    
    var presenter: ModalPresenter?
    
    private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    // MARK: - Setup functions
    
    private func setupView() {
        view.backgroundColor = .white
        webView.tintColor = .black
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        guard let request = presenter?.showWebView() else { return print("No request found")}
        webView.load(request)
    }
    
    private func setupHierarchy() {
        view.addSubview(topView)
        topView.addSubview(saveButton)
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
        saveButton.snp.makeConstraints { make in
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

// MARK: - ModalViewProtocol Impl

extension ModalViewController: ModalViewProtocol {
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    @objc func saveButtonTapped() {
        let alert = UIAlertController(title: "Do you want to save file?",
                                           message: "",
                                           preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Yes",
                                           style: .default,
                                           handler: { [weak self] _ in
                 self?.presenter?.saveFile()
             }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
    
    func showSavedAlert(urlFilePath: URL) {
        let alert = UIAlertController(title: "Your file saved!",
                                       message: "",
                                       preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back",
                                           style: .default,
                                           handler: nil))
        alert.addAction(UIAlertAction(title: "Open file",
                                           style: .default,
                                      handler: { _ in
            let path = urlFilePath.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
            guard let url = URL(string: path) else { return print("No URL-path found") }
            UIApplication.shared.open(url)
        }))
        self.present(alert, animated: true)
    }

    func showNotSavedAlert() {
        let alert = UIAlertController(title: "Your file has not been saved!",
                                           message: "",
                                           preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil))
        self.present(alert, animated: true)
    }
}
