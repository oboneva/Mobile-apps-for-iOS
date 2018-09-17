//
//  Utilities.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ViewController.h"
#import "SinglePlayerViewController.h"
#import "MultiplePlayersViewController.h"
#import "GameViewController.h"
#import "MatrixCollectionViewController.h"
#import "ScoreboardTableViewController.h"
#import "JoinRoomViewController.h"
#import "GameTypeViewController.h"
#import "GameModeViewController.h"
#import "EnemyTypeViewController.h"
#import "NetworkGameViewController.h"
#import "CreateRoomViewController.h"
#import "ArrangeShipsViewController.h"

#import "Utilities.h"
#import "Constants.h"

#import "BotMediumModel.h"
#import "BotEasyModel.h"
#import "BotHardModel.h"
#import "ShipModel.h"

#import "TicTacToeEngine.h"
#import "TunakTunakTunEngine.h"
#import "BattleshipsEngine.h"

@implementation Utilities

+ (int)randomNumberWithUpperBound:(int)upperBound {
    return arc4random_uniform(upperBound);
}

+ (UIViewController *) viewControllerWithClass:(Class)class {
    NSString *identifier = Utilities.classIdentifiers[class];
    
    UIViewController *vc;
    if (identifier) {
        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
    }
    else {
        vc = [[class alloc] init];
    }
    
    return vc;
}

+ (NSDictionary<Class, NSString *> *)classIdentifiers {
    static NSDictionary<Class, NSString *> *idents = nil;
    if (!idents) {
        idents = @{ ViewController.class : IDENTIFIER_MAIN_VIEW_CONTROLLER,
                    MatrixCollectionViewController.class : IDENTIFIER_GAME_VIEW_CONTROLLER,
                    GameViewController.class : IDENTIFIER_GAME_VIEW_CONTROLLER,
                    SinglePlayerViewController.class : IDENTIFIER_SINGLE_PLAYER_VIEW_CONTROLLER,
                    MultiplePlayersViewController.class : IDENTIFIER_MULTIPLE_PLAYERS_VIEW_CONTROLLER,
                    GameViewController.class : IDENTIFIER_GAME_TABLE_VIEW_CONTROLLER,
                    ScoreboardTableViewController.class : IDENTIFIER_SCOREBOARD_VIEW_CONTROLLER,
                    JoinRoomViewController.class : IDENTIFIER_JOIN_ROOM_VIEW_CONTROLLER,
                    GameTypeViewController.class : IDENTIFIER_GAME_TYPE_VIEW_CONTROLLER,
                    GameModeViewController.class : IDENTIFIER_GAME_MODE_VIEW_CONTROLLER,
                    EnemyTypeViewController.class : IDENTIFIER_ENEMY_TYPE_VIEW_CONTROLLER,
                    NetworkGameViewController.class : IDENTIFIER_NETWORK_GAME_VIEW_CONTROLLER,
                    CreateRoomViewController.class : IDENTIFIER_CREATE_ROOM_VIEW_CONTROLLER,
                    ArrangeShipsViewController.class : IDENTIFIER_ARRANGE_SHIPS_VIEW_CONTROLLER
                  };
    }
    
    return idents;
}

+ (GameEngine *)gameEngineFromType:(EnumGame)type {
    NSString *identifier = Utilities.gameIdentifiers[[NSNumber numberWithInt:type]];
    return [[NSClassFromString(identifier) alloc] initWithEmptyCells];
}

+ (NSDictionary<NSNumber *, NSString *> *) gameIdentifiers {
    static NSDictionary<NSNumber *, NSString *> *idents = nil;
    if (!idents) {
        idents = @{ [NSNumber numberWithInt:EnumGameTicTacToe] : NSStringFromClass(TicTacToeEngine.class),
                    [NSNumber numberWithInt:EnumGameTunakTunakTun] : NSStringFromClass(TunakTunakTunEngine.class),
                    [NSNumber numberWithInt:EnumGameBattleships] : NSStringFromClass(BattleshipsEngine.class)
                    };
    }
    return idents;
}

+ (id) botWithDifficulty:(EnumDifficulty)difficulty {
    NSString *identifier = Utilities.botIdentifiers[[NSNumber numberWithInt:difficulty]];
    return [[NSClassFromString(identifier) alloc] init];
}

+ (NSDictionary<NSNumber *, NSString *> *) botIdentifiers {
    static NSDictionary<NSNumber *, NSString *> *idents = nil;
    if (!idents) {
        idents = @{ [NSNumber numberWithInt:EnumDifficultyEasy] : NSStringFromClass(BotEasyModel.class),
                    [NSNumber numberWithInt:EnumDifficultyMedium] : NSStringFromClass(BotMediumModel.class),
                    [NSNumber numberWithInt:EnumDifficultyHard] : NSStringFromClass(BotHardModel.class)
                    };
    }
    return idents;
}

+ (NSDictionary<NSString *, UIColor *> *) shipsColors {
    static NSDictionary<NSString *, UIColor *> *colors = nil;
    if (!colors) {
        colors = @{ @"Carrier" : [UIColor blueColor],
                    @"Battleship" : [UIColor yellowColor],
                    @"Submarine" : [UIColor cyanColor],
                    @"Destroyer" : [UIColor purpleColor],
                    @"Patrol Craft" : [UIColor orangeColor],
                    };
    }
    return colors;
}

+ (UIColor *)colorForShipWithName:(NSString *)shipName {
    return Utilities.shipsColors[shipName];
}

+ (NSArray<ShipModel *> *)getDefaultShips {
    ShipModel *ship1 = [ShipModel newShipWithName:@"Carrier" andSize:5];
    ShipModel *ship2 = [ShipModel newShipWithName:@"Battleship" andSize:4];
    ShipModel *ship3 = [ShipModel newShipWithName:@"Destroyer" andSize:3];
    ShipModel *ship4 = [ShipModel newShipWithName:@"Submarine" andSize:3];
    ShipModel *ship41 = [ShipModel newShipWithName:@"Submarine" andSize:3];
    ShipModel *ship5 = [ShipModel newShipWithName:@"Patrol Craft" andSize:2];
    ShipModel *ship51 = [ShipModel newShipWithName:@"Patrol Craft" andSize:2];
    
    return @[ship1, ship2, ship3, ship4, ship41, ship5, ship51];
}

@end


@implementation UIView (NSLayoutConstraintFilter)

- (NSArray *)constraintsForAttribute:(NSLayoutAttribute)attribute {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", attribute];
    NSArray *filteredArray = [[self constraints] filteredArrayUsingPredicate:predicate];
    
    return filteredArray;
}

- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute {
    NSArray *constraints = [self constraintsForAttribute:attribute];
    
    if (constraints.count) {
        return constraints[0];
    }
    
    return nil;
}

@end

