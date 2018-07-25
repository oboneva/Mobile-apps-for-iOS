//
//  GameEngine.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "GameEngine.h"

#import "Constants.h"
#import "Utilities.h"
#import "Protocols.h"

#import "GameCellModel.h"
#import "PlayerModel.h"
#import "BotModel.h"

#import <UIKit/UIKit.h>

@interface GameEngine ()

@property (strong, nonatomic) NSArray<NSArray<GameCellModel *> *> *gameMatrix;
- (BOOL)isWinnerPlayerAtIndex:(NSIndexPath *)indexPath;
- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)markCellSelectedAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation GameEngine

- (instancetype)initWithEmptyCells {
    
    self = [super init];
    if (self) {
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        for (int i = 0; i < ROWS_COUNT; i++) {
            NSMutableArray *columns = [[NSMutableArray alloc] init];
            for (int j = 0; j < ITEMS_COUNT; j++) {
                [columns addObject:[self.class.cellType emptyCell]];
            }
            [rows addObject:[[NSArray alloc] initWithArray:columns]];
        }
        self.gameMatrix  = [[NSArray alloc] initWithArray:rows];
    }
    
    return self;
}

+(Class)cellType
{
    return GameCellModel.class;
}

- (GameCellModel *)getCellAtIndex:(NSIndexPath *)indexPath {
    return self.gameMatrix[indexPath.section][indexPath.item];
}

-(void)markCellSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    //Does nothing in base class
}

- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath {
    [self markCellSelectedAtIndexPath:indexPath];
    if ([self isWinnerPlayerAtIndex:indexPath])
    {
        [self updateRankingForPlayer:self.currentPlayer];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
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
    
    if ([self.player1.class isEqual:self.player2.class]) {
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

- (BOOL)isWinnerPlayerAtIndex:(NSIndexPath *)indexPath {
    GameCellModel *winCell = self.gameMatrix[indexPath.section][indexPath.item];
    
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

- (void)setUpPlayers {
    int random = [Utilities randomNumberWithUpperBound:2];
    if (random == 0) {
        self.player1.symbol = FIRST_PLAYER_SYMBOL;
        self.player2.symbol = SECOND_PLAYER_SYMBOL;
        self.currentPlayer = self.player1;
    }
    else {
        self.player1.symbol = SECOND_PLAYER_SYMBOL;
        self.player2.symbol = FIRST_PLAYER_SYMBOL;
        self.currentPlayer = self.player2;
    }
}

- (int)rowsCount {
    return ROWS_COUNT;
}

- (int)itemsCount {
    return ITEMS_COUNT;
}

- (BOOL)isCellAtIndexPathSelectable:(NSIndexPath *)indexPath {
    if ([self.currentPlayer isKindOfClass:BotModel.class]) {
        return false;
    }
    return true;
}

- (void)notifyTheNextPlayer {
    if (self.filled_cells >= ROWS_COUNT * ITEMS_COUNT) {
        //END CONDITION
        [self.endGameDelegate didEndGameWithNoWinner];
    }
    else {
        // update the UI
        [self.notifyPlayerToPlayDelegate didChangePlayerToPlayWithName:self.currentPlayer.name];
        [self handleMovementByPlayer:self.currentPlayer];
    }
}

- (void)handleMovementByPlayer:(PlayerModel *)player {
    if ([player isKindOfClass:BotModel.class]) {
        [self playerSelectedItemAtIndexPath:[(BotModel *)player makeMove]];
    }
    else {
        //wait for input
        [self.endGameDelegate forceRefresh];
    }
}

- (BOOL)areCoordinatesValidX:(int)x andY:(int)y {
    return x >= 0 && x < ROWS_COUNT && y >= 0 && y < ITEMS_COUNT;
}

@end
