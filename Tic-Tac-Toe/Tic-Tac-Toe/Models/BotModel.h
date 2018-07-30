//
//  BotModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "PlayerModel.h"
#import "Protocols.h"

@interface BotModel : PlayerModel

- (NSIndexPath *)makeMove;
- (void)makeTheMoveSpecific;
@property (weak, nonatomic)id<BoardStateDelegate>boardStateDelegate;

@end
