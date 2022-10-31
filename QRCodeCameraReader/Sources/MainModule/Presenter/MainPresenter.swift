//
//  MainPresenter.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func buttonTapped()
}

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, router: CameraRouterProtocol)
    func startScan()
    func showModalView(link: Model?)
}

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    private var router: CameraRouterProtocol?
    
    required init(view: MainViewProtocol, router: CameraRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func startScan() {
        view?.buttonTapped()
    }

    func showModalView(link: Model?) {
        router?.showModalViewController(link: link)
    }
}
