//
//  ModalPresenter.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 31.10.2022.
//
import Foundation

protocol ModalViewProtocol: AnyObject {
    func shareAction()
    func closeView()
}

protocol ModalPresenterProtocol: AnyObject {
    init(view: ModalViewProtocol, manager: DataManagerProtocol, router: CameraRouterProtocol, link: Model?)
    func showWebView()
    func saveFile()
}

class ModalPresenter: ModalPresenterProtocol {
    var link: Model?
    weak var view: ModalViewProtocol?
    private let manager: DataManagerProtocol
    private let router: CameraRouterProtocol?
    
    required init(view: ModalViewProtocol, manager: DataManagerProtocol, router: CameraRouterProtocol, link: Model?) {
        self.view = view
        self.manager = manager
        self.link = link
        self.router = router
    }
    
    func showWebView() {
        manager.makeRequest(link: link!)
        
    }
    
    func saveFile() {
        manager.saveFile(link: link!)
        router?.showAlert(alert: manager.alertToShow!)
    }
}
