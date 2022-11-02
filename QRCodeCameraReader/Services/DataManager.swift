//
//  CaptureManager.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.

import UIKit

protocol DataManagerProtocol: AnyObject {
    func makeRequest(link: String, completion: (URLRequest) -> Void)
    func saveFile(link: String, completion: (URL) -> Void)
}

class DataManagerImpl: DataManagerProtocol {
    func makeRequest(link: String, completion: (URLRequest) -> Void)  {
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            completion(request)
            print("Sucsess")
        } else {
            print("Incorrect link")
        }
    }
    
    func saveFile(link: String, completion: (URL) -> Void) {
        guard let url = URL(string: link) else { return }
        let pdfdata = try? Data.init(contentsOf: url)
        if let documentPath = FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask).last {
            let pdfFileName = "\(UUID().uuidString).pdf"
            let filePath = documentPath.appendingPathComponent(pdfFileName)
            do {
                try pdfdata?.write(to: filePath, options: .atomic)
                completion(documentPath)
                print("File saved")
            } catch {
                print("Error")
            }
        }
    }
}

