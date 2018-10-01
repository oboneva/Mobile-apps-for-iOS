//
//  Utilities.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 26.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "Utilities.h"
#import "ShapesCollectionViewDataSource.h"
#import "ColorsCollectionViewDataSource.h"

@implementation Utilities

+ (CollectionViewDataSource *)dataSourceForToolboxItem:(ToolboxItemType)item {
    if (item == ToolboxItemTypeShape) {
        return [ShapesCollectionViewDataSource newDataSource];
    }
    else if (item == ToolboxItemTypeColor) {
        return [ColorsCollectionViewDataSource newDataSource];
    }
    return (CollectionViewDataSource *)nil;
}

+ (NSString *)itemTypeToString:(ToolboxItemType)type {
    return [[Utilities stringItemTypes] objectForKey:[NSNumber numberWithInteger:type]];
}

+ (NSString *)shapeTypeToString:(ShapeType)type {
    return [[Utilities stringShapeTypes] objectForKey:[NSNumber numberWithInteger:type]];
}

+ (NSDictionary<NSNumber *, NSString *> *)stringItemTypes {
    return @{[NSNumber numberWithInteger:ToolboxItemTypePen] : @"pen",
             [NSNumber numberWithInteger:ToolboxItemTypeColor] : @"color",
             [NSNumber numberWithInteger:ToolboxItemTypeShape] : @"shape",
             [NSNumber numberWithInteger:ToolboxItemTypeArrow] : @"arrow",
             [NSNumber numberWithInteger:ToolboxItemTypeWidth] : @"width",
             [NSNumber numberWithInteger:ToolboxItemTypeTextUnderline] : @"textUnderline",
             [NSNumber numberWithInteger:ToolboxItemTypeTextHighlight] : @"textHighlight",
             [NSNumber numberWithInteger:ToolboxItemTypeTextStrikeThrough] : @"textStrikeThrough",
             [NSNumber numberWithInteger:ToolboxItemTypeUndo] : @"undo",
             [NSNumber numberWithInteger:ToolboxItemTypeRedo] : @"redo",
             };
}

+ (NSDictionary<NSNumber *, NSString *> *)stringShapeTypes {
    return @{[NSNumber numberWithInteger:ShapeTypeCircle] : @"circle",
             [NSNumber numberWithInteger:ShapeTypeRegularRectangle] : @"regularRectangle",
             [NSNumber numberWithInteger:ShapeTypeRoundedRectangle] : @"roundedRectangle"
             };
}

+ (UIViewController *)viewControllerFromClass:(Class *)class {
    return (UIViewController *)nil;
}

@end
