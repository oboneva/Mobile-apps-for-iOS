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


@implementation GameEngine

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
