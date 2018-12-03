//
//  ShapeModel.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 7.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ShapeModel: NSObject {

    let type: ShapeType!
    let image: UIImage!
    let imageNamePrefix: String = "toolbox-shape-"
    
    init(withShapeType type: ShapeType) {
        self.type = type
        image = UIImage(named: imageNamePrefix + type.description)
    }
}
