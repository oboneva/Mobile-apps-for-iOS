//
//  Protocols.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 28.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#ifndef Protocols_h
#define Protocols_h

#import "Constants.h"

@protocol ToolboxItemOptionsDelegate <NSObject>

- (void)didChooseOption:(NSInteger)option forItem:(ToolboxItemType)itemType;
- (void)didChooseColor:(UIColor *)color;
- (void)didChooseLineWidth:(CGFloat)width;

@end

#endif /* Protocols_h */
