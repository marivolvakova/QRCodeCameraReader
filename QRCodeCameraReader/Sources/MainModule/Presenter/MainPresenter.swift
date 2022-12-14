//
//  MainPresenter.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.
//

import Foundation

// MARK: - MainViewProtocol

protocol MainViewProtocol: AnyObject {
    func setupLabelText(link: String?)
    func buttonTapped()
}

// MARK: - MainPresenterProtocol

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, router: CameraRouterProtocol)
    func startScan()
    func showModalView(link: String?)
}

// MARK: - MainPresenter

class MainPresenter: MainPresenterProtocol {
    
    // MARK: - Properties
    weak var view: MainViewProtocol?
    private var router: CameraRouterProtocol?
    
    // MARK: - Initialize
    
    required init(view: MainViewProtocol, router: CameraRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    // MARK: - Functions
    
    func startScan() {
        view?.buttonTapped()
    }
    
    func updateLableText(link: String?) {
        view?.setupLabelText(link: link)
    }
    
    func showModalView(link: String?) {
        router?.showModalViewController(link: link)
    }
}
