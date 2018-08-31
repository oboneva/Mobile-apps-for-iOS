//
//  BotHardModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "BotHardModel.h"
#import "Utilities.h"

@implementation BotHardModel //not avaiable for battleships

- (NSIndexPath *)makeMove{
    NSArray<NSIndexPath *> *available = [self.boardStateDelegate availableCells];
    if (available.count > 1) {
        [NSThread sleepForTimeInterval:5];
    }
    
    int count = [self.boardStateDelegate emptyCellsCount];
    if (count < 8) {
        for (NSIndexPath *index in available) {
            if ([self.boardStateDelegate isWinCombinationAtIndexPathForMe:index]) {
                return index;
            }
        }
        for (NSIndexPath *index in available) {
            if ([self.boardStateDelegate isWinCombinationAtIndexPathForOther:index]) {
                return index;
            }
        }
    }

    return available[[Utilities randomNumberWithUpperBound:available.count]];
}

- (NSString *)name {
    return @"Bot-Hard";
}

@end
