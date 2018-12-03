//
//  LineWidthViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class LineWidthViewController: UIViewController {

    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var widthImageView: UIImageView!
    weak var toolboxItemDelegate: ToolboxItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSlide(_ sender: UISlider) {
        setLineWidth(width: sender.value)
        toolboxItemDelegate?.didChoose(lineWidth: sender.value)
    }
    
    func setLineWidth(width : Float) {
        UIGraphicsBeginImageContext(widthImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(CGFloat(width))
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.beginPath()
        context?.move(to: CGPoint(x:0, y:widthImageView.frame.origin.y / 2))
        context?.addLine(to: CGPoint(x:widthImageView.frame.size.width, y:widthImageView.frame.origin.y / 2))
        context?.strokePath()
        widthImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
    }
}
