//
//  ToolboxItemModel.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 27.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToolboxItemModel : NSObject

+ (instancetype)newItemFromType:(ToolboxItemType)itemType;
@property (strong, nonatomic, readonly)UIImage *image;
@property (assign, readonly)ToolboxItemType type;
@property (assign, readonly)BOOL isOptionsSet;

@end

NS_ASSUME_NONNULL_END
