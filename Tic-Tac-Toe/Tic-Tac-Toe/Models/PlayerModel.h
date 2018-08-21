//
//  PlayerModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 17.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class GameCellModel;
@interface PlayerModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (assign) EnumSymbol symbol;

- (instancetype) initWithName:(NSString *)name;
- (void)makeMove;

@end
