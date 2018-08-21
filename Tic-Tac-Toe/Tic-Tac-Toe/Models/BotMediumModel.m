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
    [NSThread sleepForTimeInterval:2];
    NSArray *available = [self.boardStateDelegate availableCells];
    NSIndexPath *index = available[[Utilities randomNumberWithUpperBound:available.count] ];
    
    return index;
}

- (NSString *)name {
    return @"Just Bot";
}

@end
