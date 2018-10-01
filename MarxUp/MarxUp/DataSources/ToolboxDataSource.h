//
//  ToolboxDataSource.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 27.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToolboxDataSource : NSObject

+ (instancetype)newDataSource;
- (int)numberOfToolboxItems;
- (void)initItemWithButton:(UIButton *)button atIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
