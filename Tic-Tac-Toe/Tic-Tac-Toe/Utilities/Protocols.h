//
//  Protocols.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#ifndef Protocols_h
#define Protocols_h

#import "Constants.h"

@class PlayerModel;
@class GameCellModel;
@protocol EndGameDelegate

- (void)didEndGameWithWinner:(PlayerModel *)winner;
- (void)didEndGameWithNoWinner;

-(void)forceRefresh;

@end

@protocol NotifyPlayerToPlayDelegate

- (void)didChangePlayerToPlayWithName:(NSString *)playerName;

@end

@protocol BoardStateDelegate

- (NSArray<NSIndexPath *> *)availableCells;

@end

//
@protocol MultipleDevicesGameMessagingDelegate

- (void)sendCellMarkedAtIndexPath:(NSIndexPath *)indexPath;
- (void)receiveCellMarkedAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol EngineDelegate

- (EnumGame)getGameType;
- (EnumGameMode)getGameMode;
@property (strong, nonatomic) PlayerModel *currentPlayer;
@property (strong, nonatomic) PlayerModel *player1;
@property (strong, nonatomic) PlayerModel *player2;

- (int)rowsCount;
- (int)itemsCount;
- (GameCellModel *)getCellAtIndex:(NSIndexPath *)indexPath;
- (BOOL)isCellAtIndexPathSelectable:(NSIndexPath *)indexPath;
- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)newGame;
- (void)startGame;

@end

#endif /* Protocols_h */
