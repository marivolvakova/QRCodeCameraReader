//
//  Router.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 31.10.2022.
//

import UIKit

// MARK: - RouterProtocol

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyModule: ModuleAssemblyProtocol? { get set }
}

// MARK: - CameraRouterProtocol

protocol CameraRouterProtocol: RouterProtocol {
    func initializeViewControllers()
    func showModalViewController(link: Model?)
    func showAlert(alert: UIAlertController)
}

// MARK: - Router

class Router: CameraRouterProtocol {
    var navigationController: UINavigationController?
    var assemblyModule: ModuleAssemblyProtocol?

    init(navigationController: UINavigationController, assemblyModule: ModuleAssemblyProtocol) {
        self.navigationController = navigationController
        self.assemblyModule = assemblyModule
    }

    func initializeViewControllers() {
        if let navigationController = navigationController {
            guard let cameraViewController = assemblyModule?.createMainModule(router: self) else { return }
            navigationController.viewControllers = [cameraViewController]
        }
    }

    func showModalViewController(link: Model?) {
        if let navigationController = navigationController {
            guard let modalViewController =
                    assemblyModule?.createModalModule(router: self, link: link) else { return }
            navigationController.present(modalViewController, animated: true)
        }
    }

    func showAlert(alert: UIAlertController) {
        if let navigationController = navigationController {
            let modalViewController = ModalViewController()
            modalViewController.present(alert, animated: true)
        }
    }
}
