//
//  ToolboxViewController.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 24.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToolboxViewController : UIViewController <UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic)id<EditedContentStateDelegate> editedContentStateDelegate;
@property (weak, nonatomic)id<ToolboxItemDelegate> toolboxItemDelegate;
@property (assign)ContentType buttonsForContentType;;

@end

NS_ASSUME_NONNULL_END
