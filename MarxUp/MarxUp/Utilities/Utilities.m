//
//  Utilities.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 26.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "Utilities.h"

#import "ShapesCollectionViewDataSource.h"
#import "ArrowsCollectionViewDataSource.h"

#import "DocumentPreviewTableViewController.h"
#import "ImagePreviewViewController.h"
#import "ToolboxItemViewController.h"
#import "SingleDocumentViewController.h"
#import "SingleImageViewController.h"
#import "LineWidthViewController.h"
#import "ColorPickerViewController.h"
#import "ToolbarViewController.h"

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
    NSString *identifier = Utilities.classIdentifiers[NSStringFromClass(class)];
    
    UIViewController *viewController;
    if (identifier) {
        viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
    }
    else {
        viewController = [[class alloc] init];
    }
    
    return viewController;
}

+ (NSDictionary<NSString *, NSString *> *)classIdentifiers {
    static NSDictionary<NSString *, NSString *> *idents = nil;
    if (!idents) {
        idents = @{NSStringFromClass(DocumentPreviewTableViewController.class) : ID_DOCUMENT_PREVIEW_VIEW_CONTROLLER,
                   NSStringFromClass(ImagePreviewViewController.class) : ID_IMAGE_PREVIEW_VIEW_CONTROLLER,
                   NSStringFromClass(ToolboxItemViewController.class) : ID_TOOLBOX_ITEM_VIEW_CONTROLLER,
                   NSStringFromClass(SingleDocumentViewController.class) : ID_SINGLE_DOCUMENT_VIEW_CONTROLLER,
                   NSStringFromClass(SingleImageViewController.class) : ID_SINGLE_IMAGE_VIEW_CONTROLLER,
                   NSStringFromClass(LineWidthViewController.class) : ID_LINE_WIDTH_VIEW_CONTROLLER,
                   NSStringFromClass(ToolbarViewController.class) : ID_TOOLBAR_VIEW_CONTROLLER,
                   NSStringFromClass(ColorPickerViewController.class) : ID_COLOR_PICKER_VIEW_CONTROLLER,
                 };
    }
    
    return idents;
}

+ (NSDictionary<NSNumber *, NSString *> *)dataSources {
   return @{[NSNumber numberWithInteger:ToolboxItemTypeArrow] : NSStringFromClass(ArrowsCollectionViewDataSource.class),
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

+ (CGPoint)convertPoint:(CGPoint)point fromViewWithSize:(CGSize)viewSize andContentInAspectFitModeWithSize:(CGSize)contentSize {
    CGFloat ratioX = viewSize.width / contentSize.width;
    CGFloat ratioY = viewSize.height / contentSize.height;
    
    CGFloat scale = MIN(ratioX, ratioY);
    
    point.x -= (viewSize.width  - contentSize.width  * scale) / 2.0f;
    point.y -= (viewSize.height - contentSize.height * scale) / 2.0f;
    
    point.x /= scale;
    point.y /= scale;
    
    return point;
}

+ (CGRect)rectBetweenPoint:(CGPoint)point andOtherPoint:(CGPoint)otherPoint {
    CGFloat beginPointX = MIN(otherPoint.x, point.x);
    CGFloat beginPointY = MIN(otherPoint.y, point.y);
    CGFloat endPointX = MAX(otherPoint.x, point.x);
    CGFloat endPointY = MAX(otherPoint.y, point.y);
    CGFloat width = endPointX - beginPointX;
    CGFloat height = endPointY - beginPointY;
    
    return CGRectMake(beginPointX, beginPointY, width, height);
}

+ (NSString *)frontCameraIcon {
    return  @"camera_front_icon";

}

+ (NSString *)backCameraIcon {
    return @"camera_back_icon";
}

+ (ImagesSort)stringToEnum:(NSString *)string {
    if ([string isEqualToString:@"VIRAL"]) {
        return ImagesSortViral;
    }
    else if ([string isEqualToString:@"TOP"]) {
        return ImagesSortTop;
    }
    return ImagesSortDate;
}

@end
