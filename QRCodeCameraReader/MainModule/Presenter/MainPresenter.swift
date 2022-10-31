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
    init(view: MainViewProtocol, link: String)
    //func getLink(object: String)
}

class MainPresenter {
    
    weak var view: MainViewController?
    let manager: DataManager
    
    required init(view: MainViewController, manager: DataManager) {
        self.view = view
        self.manager = manager
    }
    

    func showModalView(with link: String) {
        let modal = ModalViewController()
        self.view?.present(modal, animated: true)
    }
    
    func makeRequest(with link: String) {
        manager.makeRequest(link: link)
    }
}
