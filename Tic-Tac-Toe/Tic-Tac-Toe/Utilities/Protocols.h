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
#import <MultipeerConnectivity/MultipeerConnectivity.h>

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
- (PlayerModel *)getCurrentPlayer;
- (PlayerModel *)getPlayer1;

- (int)rowsCount;
- (int)itemsCount;
- (GameCellModel *)getCellAtIndex:(NSIndexPath *)indexPath;
- (BOOL)isCellAtIndexPathSelectable:(NSIndexPath *)indexPath;
- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)cellMarkedAtIndexPath:(NSIndexPath *)indexPath;
- (void)startGame;

@end

@protocol PeerSearchDelegate

- (void)didFoundPeer:(MCPeerID *)peerID withInfo:(NSDictionary *)info;
- (void)didLostPeer:(MCPeerID *)peerID;

@end

@protocol PeerSessionDelegate

- (void)didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;
- (void)peer:(MCPeerID *)peerID changedState:(MCSessionState)state;

@end

#endif /* Protocols_h */
