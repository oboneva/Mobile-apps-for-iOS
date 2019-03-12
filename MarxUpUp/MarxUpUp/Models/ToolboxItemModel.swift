//
//  ToolboxItemModel.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 7.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ToolboxItemModel: NSObject {

    let image: UIImage?
    let type: ToolboxItemType
    private let imageNamePrefix: String = "toolbox-item-"

    var containsOptions: Bool {
        return type == ToolboxItemType.arrow || type == ToolboxItemType.color ||
            type == ToolboxItemType.shape || type == ToolboxItemType.width
    }

    var isTextRelated: Bool {
        return type == ToolboxItemType.textHighlight || type == ToolboxItemType.textUnderline ||
            type == ToolboxItemType.textStrikeThrough
    }

    var isForDrawing: Bool {
        return type == ToolboxItemType.arrow || type == ToolboxItemType.shape || type == ToolboxItemType.pen
    }

    init(fromType type: ToolboxItemType) {
        image = UIImage(named: imageNamePrefix + type.description)
        self.type = type
        super.init()
    }
}
