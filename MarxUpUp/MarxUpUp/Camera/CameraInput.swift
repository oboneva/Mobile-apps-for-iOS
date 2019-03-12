//
//  CameraInput.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 6.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit
import AVFoundation

class CameraInput: NSObject {

    private var captureDevice: AVCaptureDevice?
    var deviceInput: AVCaptureDeviceInput?
    var position: AVCaptureDevice.Position? {
        get {
            return captureDevice?.position
        }
        set {
            guard let position = newValue else {
                return
            }
            let new = CameraInput(withPosition: position)
            captureDevice = new.captureDevice
            deviceInput = new.deviceInput
        }
    }
    init(withPosition position: AVCaptureDevice.Position) {
        guard let captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                          for: AVMediaType.video, position: position) else {
            return
        }
        do {
            try captureDevice.lockForConfiguration()
            if captureDevice.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus) {
                captureDevice.focusMode = AVCaptureDevice.FocusMode.autoFocus
            }
            captureDevice.unlockForConfiguration()
            try deviceInput = AVCaptureDeviceInput(device: captureDevice)
        } catch {
            print("Error: " + error.localizedDescription)
        }
    }
}
