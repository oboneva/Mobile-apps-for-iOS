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

+ (instancetype) newEngineWithEmptyCells;

- (GameCellModel *)getCellAtIndex:(NSIndexPath *)indexPath;
- (BOOL)isCellAtIndexPathSelectable:(NSIndexPath *)indexPath;
- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath;

- (int)rowsCount;
- (int)itemsCount;
@property (assign) int filled_cells;

- (void)notifyTheNextPlayer;
- (void)setUpPlayers;

- (void)newGame;

@property (weak, nonatomic)id<EndGameDelegate>endGameDelegate;
@property (weak, nonatomic)id<NotifyPlayerToPlayDelegate>notifyPlayerToPlayDelegate;

@end
