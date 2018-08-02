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

#define NOTIFICATION_CHANGED_STATE                  @"MCPeerDidChangeState"
#define NOTIFICATION_RECEIVE_DATA                   @"MCPeerDidReceiveInformation"
#define NOTIFICATION_PEER_FOUND                     @"MCPeerFound"
#define NOTIFICATION_PEER_LOST                      @"MCPeerLost"
#define NOTIFICATION_PEER_WILL_JOIN                 @"MCPeerWillJoin"
#define SERVICE_TYPE                                @"game"

#define DATA_SEPARATOR                              @" "

#define TIC_TAC_TOE                                 EnumGameTicTacToe
#define TUNAK_TUNAK_TUN                             EnumGameTunakTunakTun

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

typedef enum : NSInteger {
    EnumSendDataTurn = 0,
    EnumSendDataName,
    EnumSendDataGame,
    EnumSendDataCoordinates,
    EnumSendDataState,
    EnumSendDataReadyToPlay,
} EnumSendData;

typedef enum : NSInteger {
    EnumReadyToListen = 0,
    EnumReadyToPlay,
} EnumReady;

#endif /* Constants_h */
