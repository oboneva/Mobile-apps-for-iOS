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

- (void)didChooseOption:(NSUInteger)option forItem:(ToolboxItemType)itemType;

@end

#endif /* Protocols_h */
