//
//  MainPresenter.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.
//

import Foundation
import AVFoundation

protocol MainViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol)
    func getInput()
    var input: AVCaptureInput? { get set }
}

class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol!
    var input: AVCaptureInput?
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getInput()
    }
    
    func getInput() {
        networkService.getInput { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let input):
                    self.input = input
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}
