//
//  ToolboxDataSource.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 27.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ToolboxDataSource.h"
#import "ToolboxItemModel.h"

@interface ToolboxDataSource ()

@property (strong, nonatomic) NSArray<ToolboxItemModel *> *toolboxItems;

@end


@implementation ToolboxDataSource

+ (instancetype)newDataSourceForAnnotatingContentFromType:(ContentType)contentType {
    ToolboxDataSource *newSource = [ToolboxDataSource new];
    if (newSource) {
        ToolboxItemModel *pen = [ToolboxItemModel newItemFromType:ToolboxItemTypePen];
        ToolboxItemModel *color = [ToolboxItemModel newItemFromType:ToolboxItemTypeColor];
        ToolboxItemModel *shape = [ToolboxItemModel newItemFromType:ToolboxItemTypeShape];
        ToolboxItemModel *width = [ToolboxItemModel newItemFromType:ToolboxItemTypeWidth];
        ToolboxItemModel *arrow = [ToolboxItemModel newItemFromType:ToolboxItemTypeArrow];
        
        ToolboxItemModel *undo = [ToolboxItemModel newItemFromType:ToolboxItemTypeUndo];
        ToolboxItemModel *redo = [ToolboxItemModel newItemFromType:ToolboxItemTypeRedo];
        
        newSource.toolboxItems = @[pen, shape, arrow, color, width, undo, redo];
        
        if (contentType == ContentTypePDF) {
            ToolboxItemModel *underline = [ToolboxItemModel newItemFromType:ToolboxItemTypeTextUnderline];
            ToolboxItemModel *strike = [ToolboxItemModel newItemFromType:ToolboxItemTypeTextStrikeThrough];
            ToolboxItemModel *highlight = [ToolboxItemModel newItemFromType:ToolboxItemTypeTextHighlight];
            
            newSource.toolboxItems = @[pen, shape, arrow, color, width, underline, strike, highlight, undo, redo];
        }
    }
    
    return newSource;
}

- (int)numberOfToolboxItems {
    return (int)self.toolboxItems.count;
}

- (void)initItemWithButton:(UIButton *)button atIndex:(int)index {
    ToolboxItemModel *model = self.toolboxItems[index];
    [button setImage:model.image forState:UIControlStateNormal];
    button.tag = model.type;
}

@end
