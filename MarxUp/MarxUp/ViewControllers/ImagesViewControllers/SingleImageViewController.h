//
//  SingleImageViewController.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 19.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingleImageViewController : UIViewController <UIGestureRecognizerDelegate, ToolbarButtonsDelegate>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *imageURL;

@end

NS_ASSUME_NONNULL_END
