//
//  LostGamesDataModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LostGamesDataModel : NSObject

@property (strong, nonatomic) NSString *playerName;
@property (strong, nonatomic) NSString *botName;
@property (assign) int countOfGamesLost;

- (instancetype)initWithPlayerName:(NSString *)playerName andBotname:(NSString *)botName;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
