//
//  Utilities.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 26.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class CollectionViewDataSource;

NS_ASSUME_NONNULL_BEGIN

@interface Utilities : NSObject

+ (CollectionViewDataSource *)dataSourceForToolboxItem:(ToolboxItemType)item;
+ (NSString *)shapeTypeToString:(ShapeType)type;
+ (NSString *)itemTypeToString:(ToolboxItemType)type;
+ (NSString *)arrowTypeToString:(ArrowEndLineType)type;
+ (UIViewController *)viewControllerWithClass:(Class)class;

@end

NS_ASSUME_NONNULL_END
