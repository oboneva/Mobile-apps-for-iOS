//
//  ColorPickerViewController.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 29.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorPickerViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<ToolboxItemDelegate> toolboxItemDelegate;

@end

NS_ASSUME_NONNULL_END
