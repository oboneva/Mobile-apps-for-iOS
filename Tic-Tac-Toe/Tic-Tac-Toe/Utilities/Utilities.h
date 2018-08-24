//
//  Utilities.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class GameEngine;
@class BotModel;
@class ShipModel;

@interface Utilities : NSObject

+ (int)randomNumberWithUpperBound:(int)upperBound;
+ (UIViewController *) viewControllerWithClass:(Class)class;
+ (GameEngine *)gameEngineFromType:(EnumGame)type;
+ (BotModel *) botWithDifficulty:(EnumDifficulty)difficulty;
+ (NSArray<ShipModel *> *)getDefaultShips;

@end
