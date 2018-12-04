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
    
    init(outputView view: UIView) {
        cameraInput = CameraInput(withPosition: AVCaptureDevice.Position.back)
//        guard cameraInput.deviceInput != nil else {
//            return
//        }
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        captureSession.addInput(cameraInput.deviceInput)
        captureSession.addOutput(captureOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        view.layer.addSublayer(previewLayer)
        
        super.init()
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.previewLayer.frame = view.bounds
            }
        }
    }
    
    func stopCamera() {
        captureSession.stopRunning()
    }
    
    func takePhoto() {
        let photoSetings = AVCapturePhotoSettings()
        photoSetings.isHighResolutionPhotoEnabled = true
        photoSetings.flashMode = .off
        photoSetings.isAutoStillImageStabilizationEnabled = true
        
        captureOutput.capturePhoto(with: photoSetings, delegate: self)
    }
    
    func switchCamera() {
        guard cameraInput.deviceInput != nil else {
                return
        }
        
        captureSession.removeInput(cameraInput.deviceInput)
        if cameraInput.position == AVCaptureDevice.Position.back {
            cameraInput = CameraInput(withPosition: AVCaptureDevice.Position.front)
        }
        else {
            cameraInput = CameraInput(withPosition: AVCaptureDevice.Position.back)
        }
        captureSession.addInput(cameraInput.deviceInput)
    }
    
    func updateOrientation(forView view: UIView) {
        DispatchQueue.main.async {
            self.previewLayer.frame = view.bounds
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
        DatabaseManager().save(imageWithData: imageData)
    }
}