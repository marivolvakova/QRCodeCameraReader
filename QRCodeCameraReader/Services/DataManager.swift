//
//  CaptureManager.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.

import Foundation
import UIKit


class DataManager {
    
    var requestToLoad: URLRequest?
    
    func makeRequest(link: String) {
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            requestToLoad = request
            print("Sucsess")
        } else {
            print("Incorrect link")
        }
    }
    
    func saveFile(link: String) {
        
        guard let url = URL(string: link) else { return }
        let pdfdata = try? Data.init(contentsOf: url)
        
        if let documentPath = FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask).last {
            let pdfFileName = "\(UUID().uuidString).pdf"
            let filePath = documentPath.appendingPathComponent(pdfFileName)
            
            do {
                try pdfdata?.write(to: filePath, options: .atomic)
                
                let alert = UIAlertController(title: "Your file saved!",
                                              message: "",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Back",
                                              style: .default,
                                              handler: nil))
                alert.addAction(UIAlertAction(title: "Open file",
                                              style: .default,
                                              handler: {_ in
                    let path = filePath.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
                    guard let url = URL(string: path) else { return }
                    UIApplication.shared.open(url)
                }))
                //self.present(alert, animated: true)
                print("File saved")
                
            } catch {
                let alert = UIAlertController(title: "Your file has not saved!",
                                              message: "",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK",
                                              style: .default,
                                              handler: nil))
                //self.present(alert, animated: true)
                print("Error")
            }
        }
    }
}

