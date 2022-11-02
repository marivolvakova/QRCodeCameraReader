//
//  Assambly.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 31.10.2022.
//

import Foundation
import UIKit


// MARK: - ModuleAssemblyProtocol

protocol ModuleAssemblyProtocol {
    func createMainModule(router: CameraRouterProtocol) -> UIViewController
    func createModalModule(router: CameraRouterProtocol, link: String?) -> UIViewController
}

//MARK: - AssemblyModule

class AssemblyModule: ModuleAssemblyProtocol {
    func createMainModule(router: CameraRouterProtocol) -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createModalModule(router: CameraRouterProtocol, link: String?) -> UIViewController {
        let view = ModalViewController()
        let presenter = ModalPresenter(view: view, manager: DataManagerImpl(), router: router, link: link)
        view.presenter = presenter
        return view
    }
}
