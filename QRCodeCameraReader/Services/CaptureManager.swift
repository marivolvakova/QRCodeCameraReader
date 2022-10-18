//
//  CaptureManager.swift
//  QRCodeCameraReader
//
//  Created by Мария Вольвакова on 18.10.2022.
//
//
//import UIKit
//import AVFoundation
//
//protocol CameraManagerDelegate: AnyObject {
//
//    func didReceiveZeroObject(_ sender: CameraManager)
//    func didReceiverMetadataObject(sender: CameraManager, object: String, inBounds: CGRect, message: String)
//
//}
//
//class CameraManager: NSObject {
//    weak var delegate: CameraManagerDelegate? = nil
//}
//
//
//extension CameraManager: AVCaptureMetadataOutputObjectsDelegate {
//
//    func metadataOutput(
//        _ output: AVCaptureMetadataOutput,
//        didOutput metadataObjects: [AVMetadataObject],
//        from connection: AVCaptureConnection
//    ) {
//        if metadataObjects.count == 0 {
//            delegate?.didReceiveZeroObject(self)
//            return
//        }
//        if metadataObjects.count > 0 {
//            if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
//                if object.type == AVMetadataObject.ObjectType.qr {
//                    let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: object)
//
//                    delegate?.didReceiverMetadataObject(
//                        sender: self,
//                        inBounds: barCodeObject!.bounds,
//                        message: "\(String(describing: object.stringValue ?? ""))"
//                    )
//                }
//            }
//        }
//    }
//}

//class CameraManager: NSObject {
//    weak var view: UIView?
    
//    var captureSession = AVCaptureSession()
//    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
//    let output = AVCaptureMetadataOutput()
//
//    var outputObject: AVMetadataMachineReadableCodeObject?
//
//    var qrCodeFrameView = UIView()
    
//    weak var delegate: CameraManagerDelegate? = nil
//
//    init(view: UIView) {
//        self.view = view
//    }
//
//    func startCameraSettings() {
//        setupInput()
//        setupOutput()
//
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer.frame = (view?.layer.bounds)!
//    }
//
//    func setupInput() {
//        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
//            fatalError("No video device found") }
//        do {
//            let input = try AVCaptureDeviceInput(device: captureDevice)
//            captureSession.addInput(input)
//        } catch {
//            print(error)
//            return
//        }
//    }
//
//    func setupOutput() {
//        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//        captureSession.addOutput(output)
//    }
    
//    func showCameraLayer() {
//        view?.layer.addSublayer(videoPreviewLayer)
//        captureSession.startRunning()
//    }
//}

//
//class CameraManager: AVCaptureMetadataOutputObjectsDelegate {
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//
//
//        func metadataOutput(
//            _ output: AVCaptureMetadataOutput,
//            didOutput metadataObjects: [AVMetadataObject],
//            from connection: AVCaptureConnection
//        ) {
//            if metadataObjects.count == 0 {
//                delegate?.didReceiveZeroObject(self)
//                return
//            }
//            if metadataObjects.count > 0 {
//                if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
//                    if object.type == AVMetadataObject.ObjectType.qr {
//                        let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: object)
//
//                        delegate?.didReceiverMetadataObject(
//                            sender: self,
//                            object: object.stringValue!,
//                            inBounds: barCodeObject!.bounds,
//                            message: "\(String(describing: object.stringValue ?? ""))"
//                        )
//                    }
//                }
//            }
//        }
//    }
//}

//
//class CameraManager: NSObject {
//
//    weak var delegate: CameraManagerDelegate? = nil
//    private weak var view: UIView?
//
//    var captureSession = AVCaptureSession()
//    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
//    let output = AVCaptureMetadataOutput()
//
//    init(view: UIView) {
//        self.view = view
//    }
//
//    func startSettings() {
//
//        captureSession.addOutput(output)
//        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer.frame = view?.layer.bounds ?? CGRect()
//        captureSession.startRunning()
//    }
//
//    func getInput(completion: @escaping (Result<AVCaptureInput, Error>) -> Void) {
//        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
//            fatalError("No video device found") }
//        do {
//            let input = try AVCaptureDeviceInput(device: captureDevice)
//            completion(.success(input))
//        } catch {
//            completion(.failure(error))
//            return
//        }
//    }
//}
//



