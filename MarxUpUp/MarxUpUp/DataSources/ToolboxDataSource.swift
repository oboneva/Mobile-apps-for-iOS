//
//  ToolboxDataSource.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 7.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ToolboxDataSource: NSObject {

    private let toolboxItems: [ToolboxItemModel]
    var itemsCount: Int {
        return toolboxItems.count
    }

    init(forItemsFromType type: ContentType) {
        var content = [ToolboxItemModel(fromType: .pen), ToolboxItemModel(fromType: .color),
                       ToolboxItemModel(fromType: .shape), ToolboxItemModel(fromType: .width),
                       ToolboxItemModel(fromType: .arrow), ToolboxItemModel(fromType: .undo),
                       ToolboxItemModel(fromType: .redo)]

        if type == ContentType.pdf {
            content = [ToolboxItemModel(fromType: .pen), ToolboxItemModel(fromType: .color),
                       ToolboxItemModel(fromType: .shape), ToolboxItemModel(fromType: .width),
                       ToolboxItemModel(fromType: .textUnderline), ToolboxItemModel(fromType: .textHighlight),
                       ToolboxItemModel(fromType: .textStrikeThrough), ToolboxItemModel(fromType: .undo),
                       ToolboxItemModel(fromType: .redo)]
        }

        toolboxItems = content
        super.init()
    }

    func item(atIndex index: Int) -> ToolboxItemModel {
        return toolboxItems[index]
    }

    func type(atIndex index: Int) -> ToolboxItemType {
        return item(atIndex: index).type
    }
}
