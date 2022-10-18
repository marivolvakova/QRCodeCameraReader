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

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var link: String

    required init(view: MainViewProtocol, link: String) {
        self.view = view
        self.link = link
    }
    
//    func getLink(object: String) {
//        self.link = object
//    }
}



//func getInput() {
//    cameraManager.getInput { result in
//        DispatchQueue.main.async {
//            switch result {
//            case .success(let input):
//                self.input = input
//                self.view?.success()
//            case .failure(let error):
//                self.view?.showAlert(message: "\(e)")
//                self.view?.failure(error: error)
//            }
//        }
//    }
