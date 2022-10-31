//
//  CaptureManager.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.

import Foundation
import UIKit


protocol DataManagerProtocol: AnyObject {
    var alertToShow: UIAlertController? { get }
    var requestToLoad: URLRequest? { get }
    func makeRequest(link: Model) -> URLRequest
    func saveFile(link: Model)
}

class DataManager: DataManagerProtocol {
    var requestToLoad: URLRequest?
    var alertToShow: UIAlertController?
    
    static let sharedManager = DataManager()

    func makeRequest(link: Model) -> URLRequest {
        
        if let url = URL(string: link.link) {
            let request = URLRequest(url: url)
            requestToLoad = request
            print("Sucsess")
        } else {
            print("Incorrect link")
        }
        return requestToLoad!
    }
    
    func saveFile(link: Model) {
        
        guard let url = URL(string: link.link) else { return }
        let pdfdata = try? Data.init(contentsOf: url)
        
        if let documentPath = FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask).last {
            let pdfFileName = "\(UUID().uuidString).pdf"
            let filePath = documentPath.appendingPathComponent(pdfFileName)
            
            do {
                try pdfdata?.write(to: filePath, options: .atomic)
                
                alertToShow = UIAlertController(title: "Your file saved!",
                                              message: "",
                                              preferredStyle: .alert)
                alertToShow?.addAction(UIAlertAction(title: "Back",
                                              style: .default,
                                              handler: nil))
                alertToShow?.addAction(UIAlertAction(title: "Open file",
                                              style: .default,
                                              handler: {_ in
                    let path = filePath.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
                    guard let url = URL(string: path) else { return }
                    UIApplication.shared.open(url)
                    
                }))
                print("File saved")
                
            } catch {
                alertToShow = UIAlertController(title: "Your file has not saved!",
                                              message: "",
                                              preferredStyle: .alert)
                alertToShow?.addAction(UIAlertAction(title: "OK",
                                              style: .default,
                                              handler: nil))
                print("Error")
            }
        }
    }
}

