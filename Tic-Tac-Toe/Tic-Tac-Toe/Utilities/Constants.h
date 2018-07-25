//
//  Constants.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define IDENTIFIER_GAME_CELL                        @"GameCellIdentifier"

#define IDENTIFIER_MAIN_VIEW_CONTROLLER             @"MainViewControllerID"
#define IDENTIFIER_GAME_TABLE_VIEW_CONTROLLER       @"GameTableViewControllerID"
#define IDENTIFIER_GAME_VIEW_CONTROLLER             @"GameViewControllerID"
#define IDENTIFIER_MULTIPLE_PLAYERS_VIEW_CONTROLLER @"MultiplePlayersViewControllerID"
#define IDENTIFIER_SINGLE_PLAYER_VIEW_CONTROLLER    @"SinglePlayerViewControllerID"

#define ROWS_COUNT                                  3
#define ITEMS_COUNT                                 3
#define DIRECTIONS                                  8

#define EMPTY_CELL                                  @""

#define FIRST_PLAYER_SYMBOL                         EnumCellWithX
#define SECOND_PLAYER_SYMBOL                        EnumCellWithO
#define TUNAK_TUNAK_TUN_SYMBOL                      EnumCellEmpty

#define LAST_COLOUR                                 EnumColourRed

typedef enum : NSUInteger {
    EnumDifficultyEasy = 0,
    EnumDifficultyMedium,
    EnumDifficultyHard,
} EnumDifficulty;

typedef enum : NSUInteger {
    EnumCellEmpty = 0,
    EnumCellWithX,
    EnumCellWithO,
} EnumCell;

typedef enum : NSUInteger {
    EnumColourClear = 0,
    EnumColourYellow,
    EnumColourGreen,
    EnumColourRed,
} EnumColour;

typedef enum : NSInteger {
    EnumGameTicTacToe = 0,
    EnumGameTunakTunakTun,
} EnumGame;

typedef enum : NSInteger {
    EnumPlayerSymbolX = EnumCellWithX,
    EnumPlayerSymbolO = EnumCellWithO,
} EnumPlayerSymbol;

#endif /* Constants_h */
