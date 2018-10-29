//
//  ToolboxInitializer.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 27.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities/Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToolboxInitializer : NSObject

+ (instancetype)newToolboxInitializerForViewWithContentType:(ContentType)contentType;
- (void)addToolboxItemsToView:(UIScrollView *)toolboxView withTarget:(UIViewController *)targetController andSelector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
