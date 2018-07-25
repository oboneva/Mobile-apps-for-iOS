//
//  TicTacToeEngine.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 24.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameEngine.h"

@class TicTacToeCellModel;
@interface TicTacToeEngine : GameEngine

- (TicTacToeCellModel *)getCellAtIndex:(NSIndexPath *)indexPath;

@end
