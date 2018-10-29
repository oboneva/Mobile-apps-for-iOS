//
//  ToolboxDataSource.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 27.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToolboxDataSource : NSObject

+ (instancetype)newDataSourceForAnnotatingContentFromType:(ContentType)contentType;
- (int)numberOfToolboxItems;
- (void)initItemWithButton:(UIButton *)button atIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
