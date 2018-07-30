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
#define IDENTIFIER_SCOREBOARD_CELL                  @"ScoreboardCellIdentifier"
#define IDENTIFIER_LOST_GAMES_CELL                  @"LostGamesTableViewCellIdentifier"
#define IDENTIFIER_DEVICE_CELL                      @"DeviceCellIdentifier"

#define IDENTIFIER_MAIN_VIEW_CONTROLLER             @"MainViewControllerID"
#define IDENTIFIER_GAME_TABLE_VIEW_CONTROLLER       @"GameTableViewControllerID"
#define IDENTIFIER_GAME_VIEW_CONTROLLER             @"GameViewControllerID"
#define IDENTIFIER_MULTIPLE_PLAYERS_VIEW_CONTROLLER @"MultiplePlayersViewControllerID"
#define IDENTIFIER_SINGLE_PLAYER_VIEW_CONTROLLER    @"SinglePlayerViewControllerID"
#define IDENTIFIER_SCOREBOARD_VIEW_CONTROLLER       @"ScoreboardTableViewControllerID"
#define IDENTIFIER_CONNECTIONS_VIEW_CONTROLLER      @"ConnectionsViewControllerID"

#define ROWS_COUNT                                  3
#define ITEMS_COUNT                                 3
#define DIRECTIONS                                  8
#define SCOREBOARD_SECTIONS                         2

#define EMPTY_CELL                                  @""

#define FIRST_PLAYER_SYMBOL                         EnumCellWithX
#define SECOND_PLAYER_SYMBOL                        EnumCellWithO
#define TUNAK_TUNAK_TUN_SYMBOL                      EnumCellEmpty

#define LAST_COLOUR                                 EnumColourRed

#define HUMAN_SCORES_KEY                            @"scores"
#define LOST_AGAINST_BOT_KEY                        @"lostGames"

#define SCORES_H_H_GAME                             2
#define SCORES_H_B_EASY_GAME                        1
#define SCORES_H_B_MEDIUM_GAME                      2
#define SCORES_H_B_HARD_GAME                        4

#define NOTIFICATION_CHANGED_STATE                  @"MCPeerDidChangeState"
#define NOTIFICATION_RECEIVE_DATA                   @"MCPeerDidReceiveInformation"
#define SERVICE_TYPE                                @"game"

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

typedef enum : NSInteger {
    EnumGameModeOneDevice = 0,
    EnumGameModeTwoDevices,
} EnumGameMode;

#endif /* Constants_h */
