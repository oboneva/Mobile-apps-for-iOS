//
//  BotModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "BotModel.h"
#import "ShipModel.h"
#import "BoardModel.h"
#import "Protocols.h"
#import "Utilities.h"
#import "BattleshipsCellModel.h"

@implementation BotModel

- (NSIndexPath *)makeMove {
    //This is a stub, shoudn't be called.
    return [NSIndexPath alloc];
}

- (void)arrangeShips:(NSArray<ShipModel *> *)ships onBoard:(BoardModel *)board {
    board.ships = ships;
    [board randomArrangeShips];
}

@end
