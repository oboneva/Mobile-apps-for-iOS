//
//  TicTacToeEngine.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 24.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "TicTacToeEngine.h"

#import "TicTacToeCellModel.h"
#import "PlayerModel.h"
#import "BotModel.h"

@interface TicTacToeEngine () <BoardStateDelegate>

@property (strong, nonatomic) NSArray<NSArray<TicTacToeCellModel *> *> *gameMatrix;

@end

@implementation TicTacToeEngine

+ (instancetype)newEngineWithEmptyCells {
    TicTacToeEngine* engine = [[TicTacToeEngine alloc] init];
    if (engine) {
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        for (int i = 0; i < ROWS_COUNT; i++) {
            NSMutableArray *columns = [[NSMutableArray alloc] init];
            for (int j = 0; j < ITEMS_COUNT; j++) {
                [columns addObject:[TicTacToeCellModel emptyCell]];
            }
            [rows addObject:[[NSArray alloc] initWithArray:columns]];
        }
        engine.gameMatrix  = [[NSArray alloc] initWithArray:rows];
    }
    
    return engine;
}

- (void)newGame {
    for (int i = 0; i < ROWS_COUNT; i++) {
        for (int j = 0; j < ITEMS_COUNT; j++) {
            [self.gameMatrix[i][j] clearCell];
        }
    }
    
    self.filled_cells = 0;
    [self setUpPlayers];
    if ([self.player2 isMemberOfClass:BotModel.class]) {
        BotModel *temp = (BotModel *)self.player2;
        temp.boardStateDelegate = self;
    }
    
    [self.endGameDelegate forceRefresh];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
        [self notifyTheNextPlayer];
    });
}

- (NSArray<NSIndexPath *> *)availableCells {
    NSMutableArray *accumulated = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.gameMatrix.count; i++) {
        for (int j = 0; j < self.gameMatrix[i].count; j++) {
            if ([self.gameMatrix[i][j] isSelectable]) {
                [accumulated addObject:[NSIndexPath indexPathForItem:j inSection:i]];
            }
        }
    }
    return accumulated.copy;
}

- (TicTacToeCellModel *)getCellAtIndex:(NSIndexPath *)indexPath {
    return self.gameMatrix[indexPath.section][indexPath.item];
}

- (BOOL)isCellAtIndexPathSelectable:(NSIndexPath *)indexPath {
    return [super isCellAtIndexPathSelectable:indexPath] && [self.gameMatrix[indexPath.section][indexPath.item] isSelectable];
}

- (void)setNewContent:(EnumPlayerSymbol)symbol forCellAtIndexPath:(NSIndexPath *)indexPath {
    self.gameMatrix[indexPath.section][indexPath.item].content = (EnumCell)symbol;
    self.filled_cells++;
}

- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setNewContent:self.currentPlayer.symbol forCellAtIndexPath:indexPath];
    if ([self isWinnerPlayerWithSymbol:self.currentPlayer.symbol atIndex:indexPath])
    {
        [self.endGameDelegate didEndGameWithWinner:self.currentPlayer];
        [self.endGameDelegate forceRefresh];
    }
    else
    {
        [self.endGameDelegate forceRefresh];
        self.currentPlayer = [self.currentPlayer isEqual:self.player1] ? self.player2 : self.player1;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
            [self notifyTheNextPlayer];
        });
    }
}

- (BOOL)isWinnerPlayerWithSymbol:(EnumPlayerSymbol)playerSymbol atIndex:(NSIndexPath *)indexPath {
    TicTacToeCellModel *winCell = [TicTacToeCellModel customCellWithContent:(EnumCell)playerSymbol];
    
    if ([self.gameMatrix[0][indexPath.item] isEqualToCell:winCell] &&
        [self.gameMatrix[1][indexPath.item] isEqualToCell:winCell] &&
        [self.gameMatrix[2][indexPath.item] isEqualToCell:winCell]) {
        return true;
    }
    
    if ([self.gameMatrix[indexPath.section][0] isEqualToCell:winCell] &&
        [self.gameMatrix[indexPath.section][1] isEqualToCell:winCell] &&
        [self.gameMatrix[indexPath.section][2] isEqualToCell:winCell]) {
        return true;
    }
    
    if (indexPath.section == indexPath.item &&
        [self.gameMatrix[0][0] isEqualToCell:winCell] &&
        [self.gameMatrix[1][1] isEqualToCell:winCell] &&
        [self.gameMatrix[2][2] isEqualToCell:winCell]) {
        return true;
    }
    
    if (indexPath.section + indexPath.item == 2 &&
        [self.gameMatrix[0][2] isEqualToCell:winCell] &&
        [self.gameMatrix[1][1] isEqualToCell:winCell] &&
        [self.gameMatrix[2][0] isEqualToCell:winCell]) {
        return true;
    }
    
    return false;
}

@end
