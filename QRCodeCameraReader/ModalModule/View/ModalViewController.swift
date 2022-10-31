//
//  ModalViewController.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.
//

import UIKit
import WebKit
import SnapKit

class ModalViewController: UIViewController, WKUIDelegate {
    
    var link = "https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf"
    
    private var modalView: ModalView? {
        guard isViewLoaded else { return nil }
        return view as? ModalView
    }
    
    override func loadView() {
        view = ModalView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        modalView?.shareButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        modalView?.closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    func loadWebView() {
        if let url = URL(string: link) {
            let myRequest = URLRequest(url: url)
            modalView?.webView.load(myRequest)
            print("Sucsess")
            modalView?.activityIndicator.stopAnimating()
        } else {
            print("Incorrect link") }
    }
    
    @objc func saveAction() {
        saveFile()
    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
    
    func saveFile() {
        let url = URL(string: self.link)
        let pdfdata = try? Data.init(contentsOf: url!)
        let resDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!) as URL
        let pdfFileName = "\(UUID().uuidString).pdf"
        let filePath = resDocPath.appendingPathComponent(pdfFileName)
        
        do {
            try pdfdata?.write(to: filePath, options: .atomic)
            
            let alert = UIAlertController(title: "Your file \(pdfFileName) saved!", message: "To check the file in the folder press GO", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "GO", style: .default, handler: {  [weak self] _ in
                
                let path = filePath.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
                let url = URL(string: path)!
                UIApplication.shared.open(url)
            } ))
            self.present(alert, animated: true)
            print("File saved")
        } catch {
            let alert = UIAlertController(title: "Your file did not saved!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            print("Some error")
        }
    }
}

