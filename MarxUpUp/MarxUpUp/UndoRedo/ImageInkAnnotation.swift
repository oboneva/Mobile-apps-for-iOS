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
    let fill: Bool

    init(withLines lines: UIBezierPath, forImage image: UIImage, andFill fill: Bool) {
        self.lines = lines
        self.image = image
        self.fill = fill
    }
}

// MARK: Command Methods
extension ImageInkAnnotation: Command {
    func execute() {
        image.draw(at: CGPoint.zero)
        if fill {
            lines.fill()
        }
        lines.stroke()
    }

    func unexecute() {
        image.draw(at: CGPoint.zero)
    }
}
