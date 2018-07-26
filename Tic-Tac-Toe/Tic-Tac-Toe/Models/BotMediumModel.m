//
//  BotModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "BotMediumModel.h"

@implementation BotMediumModel

- (void)makeTheMoveSpecific {
    [NSThread sleepForTimeInterval:2];
}

- (instancetype)initWithName {
    return [super initWithName:[self.class getDefaultName]];
}

+ (NSString *)getDefaultName {
    return @"Just Bot";
}

@end
