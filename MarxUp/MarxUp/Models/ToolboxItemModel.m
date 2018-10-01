//
//  ToolboxItemModel.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 27.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ToolboxItemModel.h"
#import "Utilities.h"

@interface ToolboxItemModel ()

@property (strong, nonatomic, readwrite)UIImage *image;
@property (assign, readwrite)ToolboxItemType type;

@end


@implementation ToolboxItemModel

+ (instancetype)newItemFromType:(ToolboxItemType)itemType {
    ToolboxItemModel *newItem = [ToolboxItemModel new];
    if (newItem) {
        newItem.type = itemType;
        newItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"toolbox-item-%@", [Utilities itemTypeToString:itemType]]];
        //if (type == Itemtype)
    }
    
    return newItem;
}
/*
+ (BOOL)isItemOptionsSet:(ToolboxItemType)type {
    
}
*/
@end
