//
//  ToolbarViewController.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 24.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToolbarViewController : UIViewController

@property (weak, nonatomic)id<ToolbarButtonsDelegate> toolbarButtonsDelegate;

@end

NS_ASSUME_NONNULL_END
