//
//  LostGamesDataModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "LostGamesDataModel.h"

@implementation LostGamesDataModel

- (instancetype)initWithPlayerName:(NSString *)playerName andBotName:(NSString *)botName {
    self = [super init];
    if (self) {
        self.playerName = playerName;
        self.botName = botName;
        self.countOfGamesLost = 1;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.playerName forKey:@"playerName"];
    [encoder encodeObject:self.botName forKey:@"botName"];
    [encoder encodeObject:[NSNumber numberWithInt:self.countOfGamesLost] forKey:@"countOfGamesLost"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.playerName = [decoder decodeObjectForKey:@"playerName"];
        self.botName = [decoder decodeObjectForKey:@"botName"];
        self.countOfGamesLost = [[decoder decodeObjectForKey:@"countOfGamesLost"] intValue];
    }
    return self;
}

@end
