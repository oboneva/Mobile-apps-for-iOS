//
//  BotModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerModel.h"
#import "Constants.h"
#import "Protocols.h"

@interface BotModel : PlayerModel

@property (nonatomic) EnumDifficulty difficulty;
- (instancetype) initWithName:(NSString *)name andDifficulty:(EnumDifficulty)difficulty;
- (NSIndexPath *)makeMove;
@property (weak, nonatomic) id<BoardStateDelegate>boardStateDelegate;

@end
