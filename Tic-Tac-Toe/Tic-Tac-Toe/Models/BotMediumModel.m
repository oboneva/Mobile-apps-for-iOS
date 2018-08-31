//
//  BotMeduimModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "BotMediumModel.h"
#import "Utilities.h"

@implementation BotMediumModel

- (NSIndexPath *)makeMove {
    NSArray *available = [self.boardStateDelegate availableCells];
    if (available.count > 1) {
        [NSThread sleepForTimeInterval:2];
    }
    NSIndexPath *index = available[[Utilities randomNumberWithUpperBound:available.count] ];
    
    return index;
}

- (NSString *)name {
    return @"Just Bot";
}

@end
