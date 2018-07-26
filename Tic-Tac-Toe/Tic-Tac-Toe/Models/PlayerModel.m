//
//  PlayerModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 17.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "PlayerModel.h"
#import "Utilities.h"
#import "Constants.h"

@interface PlayerModel ()

@property (strong, nonatomic) NSString *name;

@end

@implementation PlayerModel

- (instancetype) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (void)makeMove
{
    NSLog(@"Blank move.");
}

@end
