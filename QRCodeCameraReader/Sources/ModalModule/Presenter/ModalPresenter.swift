//
//  ModalPresenter.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 31.10.2022.
//
import UIKit

protocol ModalViewProtocol: AnyObject {
    func saveAction()
    func closeView()
    func showSavedAlert(urlFilePath: URL)
    func showNotSavedAlert()
}

protocol ModalPresenterProtocol: AnyObject {
    init(view: ModalViewProtocol, manager: DataManagerProtocol, router: CameraRouterProtocol, link: String?)
    func showWebView() -> URLRequest?
    func saveFile()
}

class ModalPresenter: ModalPresenterProtocol {
    var link: String?
    weak var view: ModalViewProtocol?
    private let manager: DataManagerProtocol
    private let router: CameraRouterProtocol?
    
    required init(view: ModalViewProtocol, manager: DataManagerProtocol, router: CameraRouterProtocol, link: String?) {
        self.view = view
        self.manager = manager
        self.link = link
        self.router = router
    }
    
    func showWebView() -> URLRequest? {
        var resultRequest: URLRequest?
        if let link = link {
                self.manager.makeRequest(link: link, completion: { [weak self] result in
                    guard self != nil else { return }
                    if result == result {
                        resultRequest = result
                    } else {
                        print("Incorrect link")
                    }
                })
        }
        return resultRequest
    }
    
    func saveFile() {
        if let link = link {
            manager.saveFile(link: link) { [weak self] urlPath in
                guard self != nil else { return }
                if urlPath == urlPath {
                    self?.view?.showSavedAlert(urlFilePath: urlPath)
                } else {
                    self?.view?.showNotSavedAlert()
                }
            }
        }
    }
}
