//
//  BattleshipsEngine.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 21.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "GameEngine.h"
#import "Constants.h"

@class BoardModel;

@interface BattleshipsEngine : GameEngine

@property (strong, nonatomic) BoardModel *boardPlayer1;
@property (strong, nonatomic) BoardModel *boardPlayer2;

- (void)clearBoards;

@end
