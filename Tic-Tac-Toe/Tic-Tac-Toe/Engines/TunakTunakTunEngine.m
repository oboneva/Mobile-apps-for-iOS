//
//  TunakTunakTunEngine.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 24.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "TunakTunakTunEngine.h"

#import "TunakTunakTunCellModel.h"
#import "PlayerModel.h"
#import "BotModel.h"

@interface TunakTunakTunEngine () <BoardStateDelegate>

@property (strong, nonatomic) NSArray<NSArray<TunakTunakTunCellModel *> *> *gameMatrix;

@end

@implementation TunakTunakTunEngine

+ (instancetype)newEngineWithEmptyCells {
    TunakTunakTunEngine* engine = [[TunakTunakTunEngine alloc] init];
    if (engine) {
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        for (int i = 0; i < ROWS_COUNT; i++) {
            NSMutableArray *columns = [[NSMutableArray alloc] init];
            for (int j = 0; j < ITEMS_COUNT; j++) {
                [columns addObject:[TunakTunakTunCellModel emptyCell]];
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

- (BOOL)isCellAtIndexPathSelectable:(NSIndexPath *)indexPath {
    return [super isCellAtIndexPathSelectable:indexPath] && [self.gameMatrix[indexPath.section][indexPath.item] isSelectable];
}

- (void)setNewColourForCellAtIndexPath:(NSIndexPath *)indexPath {
    self.gameMatrix[indexPath.section][indexPath.item].colour++;
    if (self.gameMatrix[indexPath.section][indexPath.item].colour == LAST_COLOUR) {
        self.filled_cells++;
    }
}

- (TunakTunakTunCellModel *)getCellAtIndex:(NSIndexPath *)indexPath {
    return self.gameMatrix[indexPath.section][indexPath.item];
}

- (void)updateRankingForPlayer:(PlayerModel *)player {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *scores = [defaults dictionaryForKey:SCORES_KEY].mutableCopy;
    int currentScores;
    if (!scores) {
        scores = [[NSMutableDictionary alloc] init];
    }
    if (scores[player.name]) {
        currentScores = [scores[player.name] intValue];
    }
    else {
        currentScores = 0;
    }
    
    if (self.player1.class == self.player2.class) {
        [scores setValue:[NSNumber numberWithInt:(currentScores + SCORES_H_H_GAME)] forKey:player.name];
    }
    else {
        BotModel *tempBot = (BotModel *)self.player2;
        if (tempBot.difficulty == EnumDifficultyEasy) {
            [scores setValue:[NSNumber numberWithInt:(currentScores + SCORES_H_B_EASY_GAME)] forKey:player.name];
        }
        else if (tempBot.difficulty == EnumDifficultyMedium) {
            [scores setValue:[NSNumber numberWithInt:(currentScores + SCORES_H_B_MEDIUM_GAME)] forKey:player.name];
        }
        else {
            [scores setValue:[NSNumber numberWithInt:(currentScores + SCORES_H_B_HARD_GAME)] forKey:player.name];
        }
    }
    [defaults setObject:scores forKey:SCORES_KEY];
}

- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setNewColourForCellAtIndexPath:indexPath];
    if ([self isWinnerPlayerAtIndex:indexPath])
    {
        [self updateRankingForPlayer:self.currentPlayer];
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

- (BOOL)isWinnerPlayerAtIndex:(NSIndexPath *)indexPath {
    TunakTunakTunCellModel *winCell = [TunakTunakTunCellModel customCellWithColour:self.gameMatrix[indexPath.section][indexPath.item].colour];
    
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
