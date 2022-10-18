//
//  CameraManager.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.
//

import Foundation
import AVFoundation

protocol CameraManagerProtocol {
    func getInput(completion: @escaping (Result<AVCaptureInput, Error>) -> Void)
}

class CameraManager: CameraManagerProtocol {
    func getInput(completion: @escaping (Result<AVCaptureInput, Error>) -> Void) {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found") }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            completion(.success(input))
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    
    
    
    
}
