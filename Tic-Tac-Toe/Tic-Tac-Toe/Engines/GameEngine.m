//
//  GameEngine.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "GameEngine.h"

#import "Utilities.h"
#import "Protocols.h"
#import "UserDefaultsManager.h"

#import "GameCellModel.h"
#import "PlayerModel.h"
#import "HumanModel.h"
#import "BotModel.h"
#import "BotMediumModel.h"
#import "BotEasyModel.h"
#import "BotHardModel.h"
#import "LostGamesDataModel.h"

#import <UIKit/UIKit.h>

#define SCORES_H_H_GAME                             2
#define SCORES_H_B_EASY_GAME                        1
#define SCORES_H_B_MEDIUM_GAME                      2
#define SCORES_H_B_HARD_GAME                        4

#define ROWS_COUNT                                  3
#define ITEMS_COUNT                                 3
#define DIRECTIONS                                  8

@interface GameEngine () <BoardStateDelegate>

@property (strong, nonatomic) NSArray<NSArray<GameCellModel *> *> *gameMatrix;
- (BOOL)isWinnerPlayerAtIndex:(NSIndexPath *)indexPath;
- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)markCellSelectedAtIndexPath:(NSIndexPath *)indexPath;

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

+(Class)cellType {
    return GameCellModel.class;
}

- (GameCellModel *)getCellAtIndex:(NSIndexPath *)indexPath {
    return self.gameMatrix[indexPath.section][indexPath.item];
}

-(void)markCellSelectedAtIndexPath:(NSIndexPath *)indexPath {
    //Does nothing in base class
}

- (void)unmarkCellAtIndexPath:(NSIndexPath *)indexPath {
    //Does nothing in base class
}

- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath {
    [self markCellSelectedAtIndexPath:indexPath];
    if ([self isWinnerPlayerAtIndex:indexPath]) {
        if ([self.currentPlayer isMemberOfClass:HumanModel.class]) {
            [self updateRankingForHumanPlayer:self.currentPlayer];
        }
        else {
            [self updateLostGames];
        }
        [self.endGameDelegate didEndGameWithWinner:self.currentPlayer];
        [self.endGameDelegate forceRefresh];
    }
    else {
        [self.endGameDelegate forceRefresh];
        self.currentPlayer = [self.currentPlayer isEqual:self.player1] ? self.player2 : self.player1;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
            [self notifyTheNextPlayer];
        });
    }
}

- (BOOL)isHumanAgainstHumanGame {
    return [self.player1.class isEqual:self.player2.class];
}

- (void)updateRankingForHumanPlayer:(PlayerModel *)player {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *scores = [defaults dictionaryForKey:HUMAN_SCORES_KEY].mutableCopy;
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
    
    if ([self isHumanAgainstHumanGame]) {
        [scores setValue:[NSNumber numberWithInt:(currentScores + SCORES_H_H_GAME)] forKey:player.name];
    }
    else {
        if ([self.player2 isMemberOfClass:BotEasyModel.class]) {
            [scores setValue:[NSNumber numberWithInt:(currentScores + SCORES_H_B_EASY_GAME)] forKey:player.name];
        }
        else if ([self.player2 isMemberOfClass:BotMediumModel.class]) {
            [scores setValue:[NSNumber numberWithInt:(currentScores + SCORES_H_B_MEDIUM_GAME)] forKey:player.name];
        }
        else {
            [scores setValue:[NSNumber numberWithInt:(currentScores + SCORES_H_B_HARD_GAME)] forKey:player.name];
        }
    }
    [defaults setObject:scores forKey:HUMAN_SCORES_KEY];
}

- (void)updateLostGames {
    NSMutableArray<LostGamesDataModel *> *lostGames = [UserDefaultsManager loadCustomObject].mutableCopy;
    BOOL flag = false;
    for (LostGamesDataModel *data in lostGames) {
        if ([data.playerName isEqualToString:self.player1.name] && [data.botName isEqualToString:self.currentPlayer.name]) {
            flag = true;
            data.countOfGamesLost++;
        }
    }
    if(!flag) {
        [lostGames addObject:[[LostGamesDataModel alloc] initWithPlayerName:self.player1.name andBotName:self.currentPlayer.name]];
    }
    
    [UserDefaultsManager saveCustomObject:lostGames.copy];
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

- (void)clearTheCells {
    for (int i = 0; i < ROWS_COUNT; i++) {
        for (int j = 0; j < ITEMS_COUNT; j++) {
            [self.gameMatrix[i][j] clearCell];
        }
    }
    self.filled_cells = 0;
}

- (void)newMultipeerGame {
    [self clearTheCells];
    [self startMultipeerGame];
}

- (void)startMultipeerGame {
    [self notifyPlayer];
}

- (void)newGame {
    [self clearTheCells];
    [self startGame];
}

- (void)startGame {
    [self setUpPlayers];
    
    if ([self.player2 isKindOfClass:BotModel.class]) {
        BotModel *temp = (BotModel *)self.player2;
        temp.boardStateDelegate = self;
    }
    
    [self notifyPlayer];
}

- (void)notifyPlayer {
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

- (void)customSetUpPlayersWithFirstPlayerOnTurn:(PlayerModel *)player {
    self.currentPlayer = player;
    if ([self.player1 isEqual:player]) {
        self.player1.symbol = FIRST_PLAYER_SYMBOL;
        self.player2.symbol = SECOND_PLAYER_SYMBOL;
    }
    else {
        self.player1.symbol = SECOND_PLAYER_SYMBOL;
        self.player2.symbol = FIRST_PLAYER_SYMBOL;
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
        [self.endGameDelegate didEndGameWithNoWinner];
    }
    else {
        [self.notifyPlayerToPlayDelegate didChangePlayerToPlayWithName:self.currentPlayer.name];
        [self handleMovementByPlayer:self.currentPlayer];
    }
}

- (void)handleMovementByPlayer:(PlayerModel *)player {
    if ([player isKindOfClass:BotModel.class]) {
        [self playerSelectedItemAtIndexPath:[(BotModel *)player makeMove]];
    }
}

- (BOOL)areCoordinatesValidX:(int)x andY:(int)y {
    return x >= 0 && x < ROWS_COUNT && y >= 0 && y < ITEMS_COUNT;
}

- (NSArray<NSIndexPath *> *)availableCells
{
    //This is a stub
    return @[];
}

- (int)emptyCellsCount {
    int count = 0;
    for (int i = 0; i < self.gameMatrix.count; i++) {
        for (int j = 0; j < self.gameMatrix[i].count; j++) {
            if ([self.gameMatrix[i][j] isEmpty]) {
                count++;
            }
        }
    }
    return count;
}

- (BOOL)isWinCombinationAtIndexPathForMe:(NSIndexPath *)indexPath {
    //stub - again
    return false;
}

- (BOOL)isWinCombinationAtIndexPathForOther:(NSIndexPath *)indexPath {
    //stub - again
    return false;
}

- (NSString *)mapParsedToString {
    NSString *map = @"";
    for (int i = 0; i < self.gameMatrix.count; i++) {
        for (int j = 0; j < self.gameMatrix[i].count; j++) {
            map = [map stringByAppendingFormat:@"|%@", [self.gameMatrix[i][j] stringRepresentation]];
        }
        map = [map stringByAppendingString:@"|\n"];
    }
    return map;
}

@end
