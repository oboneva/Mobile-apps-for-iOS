//
//  BotEasyModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "BotEasyModel.h"
#import "Utilities.h"

@implementation BotEasyModel

- (NSIndexPath *)makeMove {
    NSArray *available = [self.boardStateDelegate availableCells];
    NSIndexPath *index = available[[Utilities randomNumberWithUpperBound:available.count]];
    
    return index;
}

-(NSString *)name {
    return @"G-Eazy";
}

@end
