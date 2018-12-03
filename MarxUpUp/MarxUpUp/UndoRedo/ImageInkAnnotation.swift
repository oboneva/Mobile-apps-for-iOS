//
//  ImageInkAnnotation.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 3.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ImageInkAnnotation: NSObject {

    let lines: UIBezierPath
    var image: UIImage
    
    init(withLines lines: UIBezierPath, forImage image: UIImage) {
        self.lines = lines
        self.image = image
    }
}

//MARK: - Command Methods
extension ImageInkAnnotation: Command {
    func execute() {
        image.draw(at: CGPoint.zero)
        lines.stroke()
    }
    
    func unexecute() {
        image.draw(at: CGPoint.zero)
    }
}
