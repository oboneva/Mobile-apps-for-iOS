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
        get {
            return type == ToolboxItemType.Arrow || type == ToolboxItemType.Color || type == ToolboxItemType.Shape || type == ToolboxItemType.Width
        }
    }
    
    var isTextRelated: Bool {
        get {
            return type == ToolboxItemType.TextHighlight || type == ToolboxItemType.TextUnderline || type == ToolboxItemType.TextStrikeThrough
        }
    }
    
    var isForDrawing: Bool {
        get {
            return type == ToolboxItemType.Arrow || type == ToolboxItemType.Shape || type == ToolboxItemType.Pen
        }
    }
    
    init(fromType type: ToolboxItemType) {
        image = UIImage(named: imageNamePrefix + type.description)
        self.type = type
        super.init()
    }
}
