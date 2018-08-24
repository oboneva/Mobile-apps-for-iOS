//
//  BotModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "PlayerModel.h"
#import "Protocols.h"

@class BoardModel;

@interface BotModel : PlayerModel

- (NSIndexPath *)makeMove;
- (void)arrangeShips:(NSArray<ShipModel *> *)ships onBoard:(BoardModel *)board;
@property (weak, nonatomic)id<BoardStateDelegate>boardStateDelegate;
@property (weak, nonatomic)id<ShipsDelegate>shipsDelegate;

@end
