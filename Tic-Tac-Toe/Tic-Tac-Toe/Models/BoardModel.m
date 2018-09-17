//
//  BoardModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 21.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardModel.h"
#import "ShipModel.h"
#import "BattleshipsCellModel.h"
#import "Utilities.h"

@implementation BoardModel


- (BOOL)couldArrangeShipAtIndexPath:(NSIndexPath *)indexPath {
    for (ShipModel *ship in self.ships) {
        if([ship isCellAtIndexPathNextToThisShip:indexPath] || [ship isCellAtIndexPathPartOfThisShip:indexPath]) {
            return false;
        }
    }
    return true;
}

- (BOOL)isCellAtIndexPathPartOfShip:(NSIndexPath *)indexPath {
    for (ShipModel *ship in self.ships) {
        if ([ship isCellAtIndexPathPartOfThisShip:indexPath]) {
            return true;
        }
    }
    return false;
}

- (BOOL)playerOnThisBoardLost {
    for (ShipModel *ship in self.ships) {
        if (![ship hasSunk]) {
            return false;
        }
    }
    return true;
}

- (NSArray<NSIndexPath *> *)availableCellsForShip {
    NSMutableArray *accumulated = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.gameMatrix.count; i++) {
        for (int j = 0; j < self.gameMatrix[i].count; j++) {
            if ([self couldArrangeShipAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]]) {
                [accumulated addObject:[NSIndexPath indexPathForItem:j inSection:i]];
            }
            
        }
    }
    return accumulated.copy;
}

+ (instancetype)newBoardWithCellType:(Class)cellType rows:(int)rowsCount andColumns:(int)columnsCount { // add define
    BoardModel *newBoard = [[BoardModel alloc] init];
    if (newBoard) {
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        for (int i = 0; i < rowsCount; i++) {
            NSMutableArray *columns = [[NSMutableArray alloc] init];
            for (int j = 0; j < columnsCount; j++) {
                [columns addObject:[cellType emptyCell]];
            }
            [rows addObject:[[NSArray alloc] initWithArray:columns]];
        }
        newBoard.gameMatrix = [[NSArray alloc] initWithArray:rows];
        newBoard.ships = @[].mutableCopy;
        newBoard.rows = rowsCount;
        newBoard.columns = columnsCount;
        newBoard.filled_cells = 0;
    }
    return newBoard;
}

- (ShipModel *)shipAtIndexPath:(NSIndexPath *)indexPath {
    for (ShipModel *ship in self.ships) {
        if ([ship isCellAtIndexPathPartOfThisShip:indexPath]) {
            return ship;
        }
    }
    return (ShipModel *)nil;
}

- (void)clearBoard {
    for (int i = 0; i < self.rows; i++) {
        for (int j = 0; j < self.columns; j++) {
            [self.gameMatrix[i][j] clearCell];
        }
    }
    
    self.filled_cells = 0;
    self.ships = @[].copy;
}

- (void)randomArrangeShips {
    for (ShipModel *ship in self.ships) {
        [self arrangeShip:ship];
    }
}

- (void)arrangeShip:(ShipModel *)ship {
    NSArray<NSIndexPath *> *availableCells = [self availableCellsForShip];
    NSIndexPath *index = availableCells[[Utilities randomNumberWithUpperBound:availableCells.count]];
    
    if ([self couldArrangeShipHorizontally:ship atIndexPath:index]) {
        [self arrangeShip:ship horizontallyAtIndexPath:index];
    }
    else if ([self couldArrangeShipVertically:ship atIndexPath:index]) {
        [self arrangeShip:ship verticallyAtIndexPath:index];
    }
    else {
        [self arrangeShip:ship]; ////////////////////
    }
}

- (BOOL)couldArrangeShipHorizontally:(ShipModel *)ship atIndexPath:(NSIndexPath *)index {
    if (index.item + ship.size - 1 >= self.columns) {
        return false;
    }
    for (NSInteger i = index.item; i < index.item + ship.size; i++){
        if (![self couldArrangeShipAtIndexPath:[NSIndexPath indexPathForItem:i inSection:index.section]]){
            return false;
        }
    }
    return true;
}

- (BOOL)couldArrangeShipVertically:(ShipModel *)ship atIndexPath:(NSIndexPath *)index {
    if (index.section + ship.size - 1 >= self.rows) {
        return false;
    }
    for (NSInteger i = index.section; i < index.section + ship.size; i++){
        if (![self couldArrangeShipAtIndexPath:[NSIndexPath indexPathForItem:index.item inSection:i]]){
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

- (BOOL)couldArrangeShip:(ShipModel *)ship withHeadIndex:(NSIndexPath *)headIndex andTailIndex:(NSIndexPath *)tailIndex {
    if (headIndex.section == tailIndex.section) {
        return [self couldArrangeShipHorizontally:ship atIndexPath:headIndex];
    }
    return [self couldArrangeShipVertically:ship atIndexPath:headIndex];
}

@end
