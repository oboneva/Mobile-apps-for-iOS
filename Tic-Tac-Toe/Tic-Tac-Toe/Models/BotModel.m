//
//  BotModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "BotModel.h"
#import "Utilities.h"
#import "Constants.h"

@implementation BotModel
- (NSIndexPath *)makeMove {
    
    if (self.difficulty == EnumDifficultyMedium) {
        [NSThread sleepForTimeInterval:2.0f];
    }
    else if (self.difficulty == EnumDifficultyHard) {
        [NSThread sleepForTimeInterval:5.0f];
    }
    NSArray *available = [self.boardStateDelegate availableCells];
    NSIndexPath *index = available[[Utilities randomNumberWithUpperBound:available.count]];
    
    return index;
}

- (instancetype) initWithName:(NSString *)name andDifficulty:(EnumDifficulty)difficulty {
    self = [super initWithName:name];
    if (self) {
        self.difficulty = difficulty;
    }
    return self;
}

@end
