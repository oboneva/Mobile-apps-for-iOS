//
//  ArrowModel.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 7.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ArrowModel: NSObject {

    let image: UIImage!
    let type: ArrowEndLineType!
    let imageNamePrefix: String = "toolbox-arrow-"

    init(withType type: ArrowEndLineType) {
        self.image = UIImage(named: imageNamePrefix + type.description)
        self.type = type
    }
}
