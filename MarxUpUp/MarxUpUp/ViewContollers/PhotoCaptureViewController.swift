//
//  PhotoCaptureViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 6.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class PhotoCaptureViewController: UIViewController {

    @IBOutlet weak var photoPreviewView: UIView!
    
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    var camera: Camera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camera = Camera(outputView: self.photoPreviewView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.bringSubviewToFront(self.switchCameraButton)
        view.bringSubviewToFront(self.takePhotoButton)
        
        guard camera.cameraInput.deviceInput != nil else {
            let alertController = UIAlertController(title: "Camera is not supported by this device!", message: "", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        camera.stopCamera()
    }
    
    @IBAction func onSwitchCameraTap(_ sender: UIButton) {
        camera.switchCamera()
    }
    
    @IBAction func onTakePhotoTap(_ sender: UIButton) {
        camera.takePhoto()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        camera.updateOrientation(forView: photoPreviewView)
    }
}
