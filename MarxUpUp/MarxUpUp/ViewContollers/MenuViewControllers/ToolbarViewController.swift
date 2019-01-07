//
//  ToolbarViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ToolbarViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var toolboxButton: UIButton!
    weak var toolbarButtonsDelegate: ToolbarButtonsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setAnnotationButtons(true)
    }
    
    private func setAnnotationButtons(_ hidden: Bool) {
        saveButton.isHidden = hidden
        resetButton.isHidden = hidden
        toolboxButton.isHidden = hidden
    }
    
    @IBAction func onBackTap(_ sender: Any) {
        toolbarButtonsDelegate?.didSelectGoBack()
    }
    
    @IBAction func onAnnotateTap(_ sender: Any) {
        setAnnotationButtons(false)
        toolbarButtonsDelegate?.didSelectAnnotate()
    }
    
    @IBAction func onSaveTap(_ sender: Any) {
        toolbarButtonsDelegate?.didSelectSave()
    }
    
    @IBAction func onResetTap(_ sender: Any) {
        toolbarButtonsDelegate?.didSelectReset()
    }
    
    @IBAction func onToolboxTap(_ sender: Any) {
        toolbarButtonsDelegate?.didSelectToolbox()
    }
}
