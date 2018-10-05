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
#import "ArrowsCollectionViewDataSource.h"
#import "DocumentPreviewTableViewController.h"
#import "ToolboxItemViewController.h"
#import "SingleDocumentViewController.h"
#import "LineWidthViewController.h"

@implementation Utilities

+ (CollectionViewDataSource *)dataSourceForToolboxItem:(ToolboxItemType)item {
    return [NSClassFromString([[Utilities dataSources]objectForKey:[NSNumber numberWithInteger:item]]) newDataSource];
}

+ (NSString *)itemTypeToString:(ToolboxItemType)type {
    return [[Utilities stringItemTypes] objectForKey:[NSNumber numberWithInteger:type]];
}

+ (NSString *)shapeTypeToString:(ShapeType)type {
    return [[Utilities stringShapeTypes] objectForKey:[NSNumber numberWithInteger:type]];
}

+ (NSString *)arrowTypeToString:(ArrowEndLineType)type {
    return [[Utilities stringArrowTypes] objectForKey:[NSNumber numberWithInteger:type]];
}

+ (UIViewController *)viewControllerWithClass:(Class)class {
    NSString *identifier = Utilities.classIdentifiers[class];
    
    UIViewController *viewController;
    if (identifier) {
        viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
    }
    else {
        viewController = [[class alloc] init];
    }
    
    return viewController;
}

+ (NSDictionary<Class, NSString *> *)classIdentifiers {
    static NSDictionary<Class, NSString *> *idents = nil;
    if (!idents) {
        idents = @{DocumentPreviewTableViewController.class : ID_DOCUMENT_PREVIEW_VIEW_CONTROLLER,
                   ToolboxItemViewController.class : ID_TOOLBOX_ITEM_VIEW_CONTROLLER,
                   SingleDocumentViewController.class : ID_SINGLE_DOCUMENT_VIEW_CONTROLLER,
                   LineWidthViewController.class : ID_LINE_WIDTH_VIEW_CONTROLLER
                 };
    }
    
    return idents;
}

+ (NSDictionary<NSNumber *, NSString *> *)dataSources {
   return @{[NSNumber numberWithInteger:ToolboxItemTypeColor] : NSStringFromClass(ColorsCollectionViewDataSource.class),
            [NSNumber numberWithInteger:ToolboxItemTypeArrow] : NSStringFromClass(ArrowsCollectionViewDataSource.class),
            [NSNumber numberWithInteger:ToolboxItemTypeShape] : NSStringFromClass(ShapesCollectionViewDataSource.class)
            };
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

+ (NSDictionary<NSNumber *, NSString *> *)stringArrowTypes {
    return @{ [NSNumber numberWithInteger:ArrowEndLineTypeClosed] : @"closed",
              [NSNumber numberWithInteger:ArrowEndLineTypeOpen] : @"open"
             };
}

@end
