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
        view.backgroundColor = UIColor.clear
        setLineWidth(width: widthSlider.value)
    }
    
    @IBAction func onSlide(_ sender: UISlider) {
        setLineWidth(width: sender.value)
        toolboxItemDelegate?.didChoose(lineWidth: sender.value)
    }
    
    private func setLineWidth(width: Float) {
        UIGraphicsBeginImageContext(widthImageView.frame.size)
        
        let path = UIBezierPath()
        path.lineWidth = CGFloat(width)
        path.move(to: CGPoint(x: 0, y: widthImageView.frame.height / 2))
        path.addLine(to: CGPoint(x: widthImageView.frame.width, y: widthImageView.frame.height / 2))
        UIColor.black.setStroke()
        path.stroke()
        
        widthImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
    }
}
