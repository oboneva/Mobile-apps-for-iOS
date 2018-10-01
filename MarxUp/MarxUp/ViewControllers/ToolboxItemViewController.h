//
//  ToolboxItemViewController.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 26.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToolboxItemViewController : UIViewController <UICollectionViewDelegate>

@property (assign) ToolboxItemType itemType;
@property (weak, nonatomic)id<ToolboxItemOptionsDelegate> toolboxItemsOptionsDelegate;

@end

NS_ASSUME_NONNULL_END
