//
//  Protocols.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#ifndef Protocols_h
#define Protocols_h

@class PlayerModel;
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

#endif /* Protocols_h */
