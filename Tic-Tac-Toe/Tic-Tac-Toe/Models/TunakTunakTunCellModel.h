//
//  TunakTunakTunCellModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 24.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "GameCellModel.h"

@interface TunakTunakTunCellModel : GameCellModel

@property (assign) EnumColor color;

+ (instancetype)customCellWithColor:(EnumColor)color;
+ (instancetype)emptyCell;

- (void)clearCell;

- (BOOL)isSelectable;
- (BOOL)isEmpty;
- (BOOL)isEqualToCell:(TunakTunakTunCellModel *)other;

@end
