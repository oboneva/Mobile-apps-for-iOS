//
//  Constants.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 26.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define IDENTIFIER_TOOLBOX_ITEM_OPTIONS_CELL   @"ToolboxItemOptionsCell"

#define ID_TOOLBOX_ITEM_VIEW_CONTROLLER        @"ToolboxItemViewControllerID"
#define ID_SINGLE_DOCUMENT_VIEW_CONTROLLER     @"SingleDocumentViewControllerID"
#define ID_VIEW_CONTROLLER                     @"RootViewControllerID"

typedef enum : NSInteger {
    ToolboxItemTypeColor = 1,
    ToolboxItemTypeShape,
    ToolboxItemTypePen,
    ToolboxItemTypeArrow,
    ToolboxItemTypeWidth,
    ToolboxItemTypeTextUnderline,
    ToolboxItemTypeTextHighlight,
    ToolboxItemTypeTextStrikeThrough,
    ToolboxItemTypeUndo,
    ToolboxItemTypeRedo,
} ToolboxItemType;

typedef enum : NSUInteger {
    ShapeTypeCircle,
    ShapeTypeRoundedRectangle,
    ShapeTypeRegularRectangle,
    ShapeTypeTriangle,
} ShapeType;

#endif /* Constants_h */
