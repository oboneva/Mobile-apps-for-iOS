//
//  BotModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BotModel.h"
#import "Protocols.h"

@interface BotMediumModel : BotModel

- (void)makeTheMoveSpecific;
- (instancetype)initWithName;

@end
