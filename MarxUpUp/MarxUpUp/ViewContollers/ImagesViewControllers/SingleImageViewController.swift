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
    var image: UIImage?
    private var annotator: Annotating!
    weak var updateDatabaseDelegate: UpdateDatabaseDelegate?

    @IBOutlet weak var toolboxStackView: UIStackView!
    var toolboxDelegate: ToolboxStackController?

    override func viewDidLoad() {
        super.viewDidLoad()
        annotatedImageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        annotatedImageView.isUserInteractionEnabled = false

        annotatedImageView.image = image

        if annotator == nil, image != nil {
            annotator = Annotator(forAnnotating: annotatedImageView)
        }

        configureToolboxView()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapWithGestureRecognizer(_:)))
        tapRecognizer.delegate = self
        annotatedImageView.addGestureRecognizer(tapRecognizer)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIGraphicsEndImageContext()
    }

    private func configureToolboxView() {
        toolboxDelegate = ToolboxStackController(withStackView: toolboxStackView, andParentController: self)
        toolboxDelegate?.toolboxItemDelegate = annotator as? ToolboxItemDelegate
        toolboxDelegate?.editedContentStateDelegate = annotator as? EditedContentStateDelegate
        toolboxDelegate?.drawDelegate = self as? DrawDelegate
        toolboxStackView.superview?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        toolboxStackView.superview?.isHidden = true
        toolboxStackView.isHidden = true
        if toolboxStackView.superview != nil {
            view.bringSubviewToFront(toolboxStackView.superview!)
        }
    }

    func imageIsLoaded(_ image: UIImage) {
        if annotatedImageView != nil {
            DispatchQueue.main.async {
                self.image = image
                self.annotatedImageView.image = image
                self.annotator = Annotator(forAnnotating: self.annotatedImageView)
            }
        }
    }

    // MARK: Handle Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard image != nil else {
            return
        }

        if let touch = touches.first {
            guard let imageSize = annotatedImageView.image?.size else {
                return
            }
            let point = Utilities.convert(touch.location(in: annotatedImageView),
                                          fromViewWithSize: annotatedImageView.frame.size,
                                          andContentInAspectFitModeWithSize: imageSize)
            annotator.beginAnnotating(atPoint: point)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard image != nil else {
            return
        }

        if let touch = touches.first {
            guard let imageSize = annotatedImageView.image?.size else {
                return
            }
            let point = Utilities.convert(touch.location(in: annotatedImageView),
                                          fromViewWithSize: annotatedImageView.frame.size,
                                          andContentInAspectFitModeWithSize: imageSize)
            annotator.continueAnnotating(atPoint: point)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard image != nil else {
            return
        }

        if let touch = touches.first {
            guard let imageSize = annotatedImageView.image?.size else {
                return
            }
            let point = Utilities.convert(touch.location(in: annotatedImageView),
                                          fromViewWithSize: annotatedImageView.frame.size,
                                          andContentInAspectFitModeWithSize: imageSize)
            annotator.endAnnotating(atPoint: point)
        }
    }

// MARK: On Button Tap Methods
    @IBAction func onResetTap(_ sender: Any) {
        annotator.reset()
    }

    @IBAction func onSaveTap(_ sender: Any) {
        guard let data = annotatedImageView.image?.pngData() else {
            return
        }
        updateDatabaseDelegate?.updateImage(withData: data)
        annotator.save()
        toolboxStackView.isHidden = true
        toolboxStackView.superview?.isHidden = true
    }

    @IBAction func onToolboxTap(_ sender: Any) {
        toolboxStackView.superview?.isHidden = !toolboxStackView.isHidden
        toolboxStackView.isHidden = !toolboxStackView.isHidden
    }

}

// MARK: UIPopoverPresentationControllerDelegate Methods
extension SingleImageViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

// MARK: UIGestureRecognizerDelegate Methods
extension SingleImageViewController: UIGestureRecognizerDelegate {
    @objc func handleTapWithGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        toolboxView?.isHidden = true
    }
}

extension SingleImageViewController {
    func setDependancies(_ annotator: Annotating) {
        self.annotator = annotator
    }
}
