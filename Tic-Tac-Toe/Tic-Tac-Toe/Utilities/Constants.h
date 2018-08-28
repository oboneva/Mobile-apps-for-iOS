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
#define IDENTIFIER_SHIP_CELL                        @"ShipCellIdentifier"
#define IDENTIFIER_SCOREBOARD_CELL                  @"ScoreboardCellIdentifier"
#define IDENTIFIER_LOST_GAMES_CELL                  @"LostGamesTableViewCellIdentifier"
#define IDENTIFIER_DEVICE_CELL                      @"DeviceCellIdentifier"
#define IDENTIFIER_FOUND_GAME_CELL                  @"FoundGameCellIdentifier"

#define IDENTIFIER_MAIN_VIEW_CONTROLLER             @"MainViewControllerID"
#define IDENTIFIER_GAME_TABLE_VIEW_CONTROLLER       @"GameTableViewControllerID"
#define IDENTIFIER_GAME_VIEW_CONTROLLER             @"GameViewControllerID"
#define IDENTIFIER_MULTIPLE_PLAYERS_VIEW_CONTROLLER @"MultiplePlayersViewControllerID"
#define IDENTIFIER_SINGLE_PLAYER_VIEW_CONTROLLER    @"SinglePlayerViewControllerID"
#define IDENTIFIER_SCOREBOARD_VIEW_CONTROLLER       @"ScoreboardTableViewControllerID"
#define IDENTIFIER_GAME_TYPE_VIEW_CONTROLLER        @"GameTypeViewControllerID"
#define IDENTIFIER_GAME_MODE_VIEW_CONTROLLER        @"GameModeViewControllerID"
#define IDENTIFIER_ENEMY_TYPE_VIEW_CONTROLLER       @"EnemyTypeViewControllerID"
#define IDENTIFIER_NETWORK_GAME_VIEW_CONTROLLER     @"NetworkGameViewControllerID"
#define IDENTIFIER_CREATE_ROOM_VIEW_CONTROLLER      @"CreateRoomViewControllerID"
#define IDENTIFIER_JOIN_ROOM_VIEW_CONTROLLER        @"JoinRoomViewControllerID"
#define IDENTIFIER_ARRANGE_SHIPS_VIEW_CONTROLLER    @"ArrangeShipsViewControllerID"

#define EMPTY_TEXT                                  @""

#define FIRST_PLAYER_SYMBOL                         EnumSymbolX
#define SECOND_PLAYER_SYMBOL                        EnumSymbolO
#define TUNAK_TUNAK_TUN_SYMBOL                      EnumSymbolEmpty

#define LAST_COLOR                                  EnumColorRed

#define HUMAN_SCORES_KEY                            @"scores"
#define LOST_AGAINST_BOT_KEY                        @"lostGames"

#define KEY_NAME                                    @"name"
#define KEY_TURN                                    @"turn"
#define KEY_COORDINATES                             @"coordinates"
#define KEY_READY                                   @"ready"
#define KEY_APP                                     @"application"
#define KEY_MESSAGE                                 @"message"
#define KEY_MAP                                     @"map"                     
#define KEY_QUESTION                                @"question"
#define KEY_ANSWER                                  @"answer"
#define KEY_BOARD                                   @"board"

#define THIS_APP_NAME                               @"Tic-Tac-Toe"

#define SERVICE_TYPE                                @"tic-tac-toe"

#define TIC_TAC_TOE                                 EnumGameTicTacToe
#define TUNAK_TUNAK_TUN                             EnumGameTunakTunakTun

typedef enum : NSUInteger {
    EnumDifficultyEasy = 0,
    EnumDifficultyMedium,
    EnumDifficultyHard,
} EnumDifficulty;

typedef enum : NSUInteger {
    EnumSymbolEmpty = 0,
    EnumSymbolX,
    EnumSymbolO,
} EnumSymbol;

typedef enum : NSUInteger {
    EnumColorClear = 0,
    EnumColorYellow,
    EnumColorGreen,
    EnumColorRed,
} EnumColor;

typedef enum : NSInteger {
    EnumGameTicTacToe = 0,
    EnumGameTunakTunakTun,
    EnumGameBattleships,
} EnumGame;

typedef enum : NSInteger {
    EnumGameModeOneDevice = 0,
    EnumGameModeTwoDevices,
} EnumGameMode;

typedef enum : NSInteger {
    EnumBoardPlayer1 = 0,
    EnumBoardPlayer2,
} EnumBoard;

#endif /* Constants_h */
