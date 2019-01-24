//
//  Camera.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 6.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit
import AVFoundation

class Camera: NSObject {

    var cameraInput: CameraInput!
    private let captureSession:AVCaptureSession
    private let captureOutput:AVCapturePhotoOutput = {
            let output = AVCapturePhotoOutput()
            output.isHighResolutionCaptureEnabled = true
            output.isLivePhotoCaptureEnabled = false
            return output
    }()
    private var previewLayer: AVCaptureVideoPreviewLayer
    var position = AVCaptureDevice.Position.back
    let device = UIDevice.current
    
    private var currentVideoOrientation: AVCaptureVideoOrientation {
        return AVCaptureVideoOrientation(rawValue: device.orientation.rawValue) ?? .portrait
    }
    
    init(outputView view: UIView) {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        super.init()
        
        cameraInput = CameraInput(withPosition: position)
        guard cameraInput.deviceInput != nil else {
            return
        }

        captureSession.addInput(cameraInput.deviceInput!)
        captureSession.addOutput(captureOutput)
        
        
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        view.layer.addSublayer(previewLayer)
        
        device.beginGeneratingDeviceOrientationNotifications()
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.previewLayer.connection?.videoOrientation = self.currentVideoOrientation
                self.previewLayer.frame = view.bounds
            }
        }
    }
}

//MARK: - AVCapturePhotoCaptureDelegate Methods
extension Camera: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error while capturing photo: " + error!.localizedDescription)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Error: fileDataRepresentation for photo failed")
            return
        }
        DatabaseManager().saveImageWithData(imageData)
    }
}

extension Camera: CameraInterface {
    var isSupportedByTheDevice: Bool {
        return cameraInput.deviceInput != nil
    }
    
    func stop() {
        captureSession.stopRunning()
    }
    
    func start() {
        guard cameraInput.deviceInput != nil else {
            return
        }
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    func takePhoto() {
        guard cameraInput.deviceInput != nil else {
            return
        }
        
        if let connection = captureOutput.connection(with: .video) {
            connection.videoOrientation = currentVideoOrientation
        }
        
        let photoSetings = AVCapturePhotoSettings()
        photoSetings.isHighResolutionPhotoEnabled = true
        photoSetings.flashMode = .off
        photoSetings.isAutoStillImageStabilizationEnabled = true
        
        captureOutput.capturePhoto(with: photoSetings, delegate: self)
    }
    
    func switchPosition() {
        guard cameraInput.deviceInput != nil else {
            return
        }
        captureSession.removeInput(cameraInput.deviceInput!)
        if position == .back {
            position = .front
        }
        else {
            position = .back
        }
        cameraInput.position = position
        
        guard cameraInput.deviceInput != nil else {
            return
        }
        captureSession.addInput(cameraInput.deviceInput!)
    }
    
    func updateOrientation(forView view: UIView) {
        DispatchQueue.main.async {
            self.previewLayer.connection?.videoOrientation = self.currentVideoOrientation
            self.previewLayer.frame = view.bounds
        }
    }
    
}
