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
#import "HumanModel.h"

@interface GameEngine ()

- (BOOL)isWinnerPlayerAtIndex:(NSIndexPath *)indexPath;
- (void)markCellSelectedAtIndexPath:(NSIndexPath *)indexPath;
+ (Class)cellType;
- (GameCellModel *)getCellAtIndex:(NSIndexPath *)indexPath;

@end

@interface TicTacToeEngine () <BoardStateDelegate>

@property (strong, nonatomic) NSArray<NSArray<TicTacToeCellModel *> *> *gameMatrix;

@end

@implementation TicTacToeEngine

+(Class)cellType
{
    return TicTacToeCellModel.class;
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

- (BOOL)isCellAtIndexPathSelectable:(NSIndexPath *)indexPath {
    return [super isCellAtIndexPathSelectable:indexPath] && [self.gameMatrix[indexPath.section][indexPath.item] isSelectable];
}

- (void)setNewContent:(EnumSymbol)symbol forCellAtIndexPath:(NSIndexPath *)indexPath {
    TicTacToeCellModel *cell = self.gameMatrix[indexPath.section][indexPath.item];
    cell.content = symbol;
}

- (void)markCellSelectedAtIndexPath:(NSIndexPath *)indexPath {
    [self setNewContent:self.currentPlayer.symbol forCellAtIndexPath:indexPath];
    self.filled_cells++;
}

- (void)unmarkCellAtIndexPath:(NSIndexPath *)indexPath {
    [self setNewContent:EnumSymbolEmpty forCellAtIndexPath:indexPath];
    self.filled_cells--;
}

- (BOOL)isWinCombinationAtIndexPathForMe:(NSIndexPath *)indexPath {
    BOOL result;
    [self markCellSelectedAtIndexPath:indexPath];
    result = [self isWinnerPlayerWithSymbol:self.currentPlayer.symbol atIndex:indexPath];
    [self unmarkCellAtIndexPath:indexPath];
    
    return result;
}

- (BOOL)isWinCombinationAtIndexPathForOther:(NSIndexPath *)indexPath {
    BOOL result;
    EnumSymbol otherPlayerSymbol = EnumSymbolX;
    if (self.currentPlayer.symbol == EnumSymbolX) {
        otherPlayerSymbol = EnumSymbolO;
    }
    
    [self setNewContent:otherPlayerSymbol forCellAtIndexPath:indexPath];
    self.filled_cells++;
    result = [self isWinnerPlayerWithSymbol:otherPlayerSymbol atIndex:indexPath];
    [self unmarkCellAtIndexPath:indexPath];
    
    return result;
}

- (int)emptyCellsCount {
    //stub
    return 0;
}


- (BOOL)isWinnerPlayerAtIndex:(NSIndexPath *)indexPath {
    return [self isWinnerPlayerWithSymbol:self.currentPlayer.symbol atIndex:indexPath];
}

- (BOOL)isWinnerPlayerWithSymbol:(EnumSymbol)playerSymbol atIndex:(NSIndexPath *)indexPath {
    TicTacToeCellModel *winCell = [TicTacToeCellModel customCellWithContent:playerSymbol];
    
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
