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
        get {
            return toolboxItems.count
        }
    }
    
    init(forItemsFromType type: ContentType) {
        var content = [ToolboxItemModel(fromType: .Pen), ToolboxItemModel(fromType: .Color), ToolboxItemModel(fromType: .Shape), ToolboxItemModel(fromType: .Width), ToolboxItemModel(fromType: .Arrow), ToolboxItemModel(fromType: .Undo), ToolboxItemModel(fromType: .Redo)]
        
        if type == ContentType.PDF {
            content = [ToolboxItemModel(fromType: .Pen), ToolboxItemModel(fromType: .Color), ToolboxItemModel(fromType: .Shape), ToolboxItemModel(fromType: .Width), ToolboxItemModel(fromType: .Arrow), ToolboxItemModel(fromType: .TextUnderline), ToolboxItemModel(fromType: .TextHighlight), ToolboxItemModel(fromType: .TextStrikeThrough), ToolboxItemModel(fromType: .Undo), ToolboxItemModel(fromType: .Redo)]
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
