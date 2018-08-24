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
    for (ShipModel *ship in ships) {
        [self arrangeShip:ship onBoard:board];
    }
}

- (void)arrangeShip:(ShipModel *)ship onBoard:(BoardModel *)board {
    NSArray<NSIndexPath *> *availableCells = [board availableCellsForShip];
    NSIndexPath *index = availableCells[[Utilities randomNumberWithUpperBound:availableCells.count]];

    if ([self couldArrangeShipHorizontally:ship onBoard:board atIndexPath:index]) {
        [self arrangeShip:ship horizontallyAtIndexPath:index];
    }
    else if ([self couldArrangeShipVertically:ship onBoard:board atIndexPath:index]) {
        [self arrangeShip:ship verticallyAtIndexPath:index];
    }
    else {
        [self arrangeShip:ship onBoard:board]; ////////////////////
    }
}

- (BOOL)couldArrangeShipHorizontally:(ShipModel *)ship onBoard:(BoardModel *)board atIndexPath:(NSIndexPath *)index {
    if (index.item + ship.size - 1 >= board.columns) {
        return false;
    }
    for (NSInteger i = index.item; i < ship.size; i++){
        if ([board isCellAtIndexPathPartOfShip:[NSIndexPath indexPathForItem:i inSection:index.section]]){
            return false;
        }
    }
    return true;
}

- (BOOL)couldArrangeShipVertically:(ShipModel *)ship onBoard:(BoardModel *)board atIndexPath:(NSIndexPath *)index {
    if (index.section + ship.size - 1 >= board.rows) {
        return false;
    }
    for (NSInteger i = index.section; i < ship.size; i++){
        if ([board isCellAtIndexPathPartOfShip:[NSIndexPath indexPathForItem:index.item inSection:i]]){
            return false;
        }
    }
    return true;
}

- (void)arrangeShip:(ShipModel *)ship horizontallyAtIndexPath:(NSIndexPath *)indexPath {
    ship.head = indexPath;
    ship.tail = [NSIndexPath indexPathForItem:indexPath.item + ship.size - 1 inSection:indexPath.section];
}

- (void)arrangeShip:(ShipModel *)ship verticallyAtIndexPath:(NSIndexPath *)indexPath {
    ship.head = indexPath;
    ship.tail = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section + ship.size - 1];
}

@end
