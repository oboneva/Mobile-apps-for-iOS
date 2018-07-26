//
//  BotHardModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "BotHardModel.h"

@implementation BotHardModel

- (void)makeTheMoveSpecific {
    [NSThread sleepForTimeInterval:5];
}

- (instancetype)initWithName {
    return [super initWithName:[self.class getDefaultName]];
}

+ (NSString *)getDefaultName {
    return @"Bot-Hard";
}

@end
