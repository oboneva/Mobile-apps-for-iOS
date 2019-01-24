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
    
    private var camera: CameraInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camera = Camera(outputView: self.photoPreviewView)
        presentAlertIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        camera.start()
        photoPreviewView.bringSubviewToFront(self.switchCameraButton)
        photoPreviewView.bringSubviewToFront(self.takePhotoButton)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.isNavigationBarHidden = true
    }
    
    func presentAlertIfNeeded() {
        if camera.isSupportedByTheDevice {
            return
        }
        
        let alertController = UIAlertController(title: "Camera is not supported by this device!", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func setCustomCamera(_ camera: CameraInterface) {
        self.camera = camera
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera.stop()
    }
    
    @IBAction func onSwitchCameraTap(_ sender: UIButton) {
        camera.switchPosition()
    }
    
    @IBAction func onTakePhotoTap(_ sender: UIButton) {
        camera.takePhoto()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if isViewLoaded {
            print(size)
                camera.updateOrientation(forView: photoPreviewView, withSize: size)
        }
    }
}
