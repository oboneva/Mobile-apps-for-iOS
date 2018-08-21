//
//  GameCellModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface GameCellModel : NSObject

@property (assign) EnumSymbol content;

+ (instancetype)emptyCell;
+ (instancetype)customCellWithContent:(EnumSymbol)content;

- (void)clearCell;

- (BOOL)isEqualToCell:(GameCellModel *)other;
- (BOOL)isSelectable;
- (BOOL)isEmpty;
- (NSString *)stringRepresentation;

@end
