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

@implementation BoardModel

- (BOOL)isCellAtIndexPathPartOfShip:(NSIndexPath *)indexPath {
    for (ShipModel * ship in self.ships) {
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
            if (![self isCellAtIndexPathPartOfShip:[NSIndexPath indexPathForItem:j inSection:i]]) {
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
        newBoard.ships = [[NSArray alloc] init];
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
}

@end
