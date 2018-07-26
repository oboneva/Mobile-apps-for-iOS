//
//  BotEasyModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "BotEasyModel.h"

@implementation BotEasyModel

- (void)makeTheMoveSpecific {};

- (instancetype)initWithName {
    return [super initWithName:[self.class getDefaultName]];
}

+ (NSString *)getDefaultName {
    return @"G-Eazy";
}

@end
