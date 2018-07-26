//
//  BotModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "BotModel.h"
#import "Protocols.h"
#import "Utilities.h"

@implementation BotModel

- (NSIndexPath *)makeMove {
    [self makeTheMoveSpecific];
    NSArray *available = [self.boardStateDelegate availableCells];
    NSIndexPath *index = available[[Utilities randomNumberWithUpperBound:available.count]];
    
    return index;
}

- (void)makeTheMoveSpecific {};

@end
