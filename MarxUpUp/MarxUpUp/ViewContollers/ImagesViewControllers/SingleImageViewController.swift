//
//  SingleImageViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 9.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class SingleImageViewController: UIViewController {

    @IBOutlet weak var annotatedImageView: UIImageView!
    var toolboxView: UIView?
    var image = UIImage()
    private var annotator: Annotator!
    weak var updateDatabaseDelegate: UpdateDatabaseDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        annotatedImageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        annotatedImageView.isUserInteractionEnabled = false
        
        annotatedImageView.image = image
        annotator = Annotator(forAnnotating: annotatedImageView)
        toolboxView?.isHidden = true
        
        children.forEach { (viewController) in
            if let toolboxController = viewController as? ToolboxViewController {
                toolboxController.toolboxItemDelegate = annotator
                toolboxController.editedContentStateDelegate = annotator
            }
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapWithGestureRecognizer(_:)))
        tapRecognizer.delegate = self
        annotatedImageView.addGestureRecognizer(tapRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toolbarController = segue.destination as? ToolbarViewController {
            toolbarController.toolbarButtonsDelegate = self
        }
        else if let toolboxController = segue.destination as? ToolboxViewController {
            toolboxController.contentType = ContentType.Image
            self.toolboxView = toolboxController.view
        }
    }
    
    //MARK: - Handle Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            guard let imageSize = annotatedImageView.image?.size else {
                return
            }
            let point = Utilities.convert(touch.location(in: annotatedImageView), fromViewWithSize: annotatedImageView.frame.size, andContentInAspectFitModeWithSize: imageSize)
            annotator.beginAnnotating(atPoint: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            guard let imageSize = annotatedImageView.image?.size else {
                return
            }
            let point = Utilities.convert(touch.location(in: annotatedImageView), fromViewWithSize: annotatedImageView.frame.size, andContentInAspectFitModeWithSize: imageSize)
            annotator.continueAnnotating(atPoint: point)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            guard let imageSize = annotatedImageView.image?.size else {
                return
            }
            let point = Utilities.convert(touch.location(in: annotatedImageView), fromViewWithSize: annotatedImageView.frame.size, andContentInAspectFitModeWithSize: imageSize)
            annotator.endAnnotating(atPoint: point)
        }
    }
}

//MARK: - ToolbarButtonsDelegate Methods
extension SingleImageViewController: ToolbarButtonsDelegate {
    func didSelectReset() {
        annotatedImageView.image = annotator.originalImage
        annotator.reset()
    }
    
    func didSelectToolbox() {
        guard let view = toolboxView else {
            return
        }
        view.isHidden = !view.isHidden
    }
    
    func didSelectAnnotate() {
        annotatedImageView.isUserInteractionEnabled = true
    }
    
    func didSelectSave() {
        guard let data = annotatedImageView.image?.pngData() else {
            return
        }
        updateDatabaseDelegate?.updateImage(withData: data)
        toolboxView?.isHidden = true
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIGestureRecognizerDelegate Methods
extension SingleImageViewController: UIGestureRecognizerDelegate {
    @objc func handleTapWithGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        toolboxView?.isHidden = true
    }
}
