//
//  GameEngine.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocols.h"
#import "Constants.h"

@class GameCellModel;
@interface GameEngine : NSObject

@property (strong, nonatomic) PlayerModel *player1;
@property (strong, nonatomic) PlayerModel *player2;
@property (strong, nonatomic) PlayerModel *currentPlayer;

- (instancetype)initWithEmptyCells;

- (GameCellModel *)getCellAtIndex:(NSIndexPath *)indexPath;
- (BOOL)areCoordinatesValidX:(int)x andY:(int)y;
- (BOOL)isCellAtIndexPathSelectable:(NSIndexPath *)indexPath;
- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldDisplayContentAtIndexPath:(NSIndexPath *)indexPath;

@property (assign) EnumBoard boardOnDisplay;
- (int)rowsCount;
- (int)itemsCount;
@property (assign) int filled_cells;

- (void)notifyTheNextPlayer;
- (void)setUpPlayers;
- (void)customSetUpPlayersWithFirstPlayerOnTurn:(PlayerModel *)player;

- (void)startGame;
- (void)newGame;
- (void)startMultipeerGame;
- (void)newMultipeerGame;

- (NSString *)mapParsedToString;

@property (weak, nonatomic)id<EndGameDelegate>endGameDelegate;
@property (weak, nonatomic)id<NotifyPlayerToPlayDelegate>notifyPlayerToPlayDelegate;


@end
