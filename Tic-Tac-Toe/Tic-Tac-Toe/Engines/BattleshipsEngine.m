//
//  BattleshipsEngine.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 21.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "PlayerModel.h"
#import "ShipModel.h"
#import "BattleshipsCellModel.h"
#import "BoardModel.h"

#import "BattleshipsEngine.h"

#define ROWS_COUNT  10
#define ITEMS_COUNT 10

@interface GameEngine ()

- (void)handleMovementByPlayer:(PlayerModel *)player;

@end

@implementation BattleshipsEngine

+ (Class)cellType {
    return BattleshipsCellModel.class;
}

- (int)rowsCount {
    return ROWS_COUNT;
}

- (int)itemsCount {
    return ITEMS_COUNT;
}

- (BattleshipsCellModel *)getCellAtIndex:(NSIndexPath *)indexPath {
    if (self.boardOnDisplay == EnumBoardPlayer1) {
        return self.boardPlayer1.gameMatrix[indexPath.section][indexPath.item];
    }
    return self.boardPlayer2.gameMatrix[indexPath.section][indexPath.item];
}

- (BOOL)isCellAtIndexPathSelectable:(NSIndexPath *)indexPath {
    return [super isCellAtIndexPathSelectable:indexPath] &&
        [self.boardPlayer2.gameMatrix[indexPath.section][indexPath.item] isSelectable] && self.boardOnDisplay == EnumBoardPlayer2;
}

- (BOOL)areCoordinatesValidX:(int)x andY:(int)y {
    return x >= 0 && x < ROWS_COUNT && y >= 0 && y < ITEMS_COUNT;//todo
}

- (void)setNewContent:(EnumSymbol)symbol forCellAtIndexPath:(NSIndexPath *)indexPath onBoard:(BoardModel *)board{
    BattleshipsCellModel *cell = board.gameMatrix[indexPath.section][indexPath.item];
    cell.content = symbol;
    board.filled_cells++;
}

- (BOOL)shouldDisplayContentAtIndexPath:(NSIndexPath *)indexPath {
    return self.boardOnDisplay == EnumBoardPlayer1 && [self.boardPlayer1 isCellAtIndexPathPartOfShip:indexPath];
}

- (void)markCellSelectedAtIndexPath:(NSIndexPath *)indexPath {
    BoardModel *currentBoard = [self currentBoardOnDisplay];
    ShipModel *ship = [currentBoard shipAtIndexPath:indexPath];
    if (ship) {
        [ship hit];
        [self setNewContent:EnumSymbolX forCellAtIndexPath:indexPath onBoard:currentBoard];
    }
    else {
        [self setNewContent:EnumSymbolO forCellAtIndexPath:indexPath onBoard:currentBoard];
    }
}

- (BoardModel *)currentBoardOnDisplay {
    if (self.boardOnDisplay == EnumBoardPlayer1) {
        return self.boardPlayer1;
    }
    return self.boardPlayer2;
}

- (BOOL)isWinnerPlayerAtIndex:(NSIndexPath *)indexPath {
    if (self.currentPlayer == self.player1) {
        return [self.boardPlayer2 playerOnThisBoardLost];
    }
    return [self.boardPlayer1 playerOnThisBoardLost];
}

- (NSArray<NSIndexPath *> *)availableCells { //used by bot
    NSMutableArray *accumulated = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.boardPlayer1.gameMatrix.count; i++) {
        for (int j = 0; j < self.boardPlayer1.gameMatrix[i].count; j++) {
            if ([self.boardPlayer1.gameMatrix[i][j] isSelectable]) {
                [accumulated addObject:[NSIndexPath indexPathForItem:j inSection:i]];
            }
        }
    }
    return accumulated.copy;
}

- (instancetype)initWithEmptyCells {
    self = [super init];
    if (self) {
        self.boardPlayer1 = [BoardModel newBoardWithCellType:[BattleshipsEngine cellType] rows:ROWS_COUNT andColumns:ITEMS_COUNT];
        self.boardPlayer2 = [BoardModel newBoardWithCellType:[BattleshipsEngine cellType] rows:ROWS_COUNT andColumns:ITEMS_COUNT];
    }
    
    return self;
}

- (void)notifyTheNextPlayer {
    if (self.filled_cells >= ROWS_COUNT * ITEMS_COUNT) {
        [self.endGameDelegate didEndGameWithNoWinner];
    }
    else {
        [self seeChangesOnBoardBeforeNextMove];
        [self updateBoardOnDisplay];
        [self.notifyPlayerToPlayDelegate didChangePlayerToPlayWithName:self.currentPlayer.name];
        [self handleMovementByPlayer:self.currentPlayer];
    }
}

- (void)seeChangesOnBoardBeforeNextMove {
    [self.endGameDelegate forceRefresh];
    [NSThread sleepForTimeInterval:0.8];
}

- (void)updateBoardOnDisplay {
    if (self.currentPlayer == self.player2) {
        self.boardOnDisplay = EnumBoardPlayer1;
    }
    else {
        self.boardOnDisplay = EnumBoardPlayer2;
    }
    [self.endGameDelegate forceRefresh];
}

- (void)clearBoards {
    [self.boardPlayer1 clearBoard];
    [self.boardPlayer2 clearBoard];
}

@end
