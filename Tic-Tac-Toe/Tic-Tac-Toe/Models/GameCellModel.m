//
//  GameCellModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "GameCellModel.h"
#import "Constants.h"

@implementation GameCellModel

+ (instancetype)emptyCell {
    GameCellModel *newCell = [[GameCellModel alloc] init];
    if (newCell) {
        newCell.content = EnumSymbolEmpty;
    }
    return newCell;
}

+ (instancetype)customCellWithContent:(EnumSymbol)content {
    GameCellModel *newCell = [[GameCellModel alloc] init];
    if (newCell) {
        newCell.content = content;
    }
    return newCell;
}

- (void)clearCell {
    self.content = EnumSymbolEmpty;
}

- (BOOL)isEqualToCell:(GameCellModel *)other {
    return self.content == other.content;
}

- (BOOL)isSelectable {
    return self.content == EnumSymbolEmpty;
}

- (BOOL)isEmpty {
    return [self isSelectable];
}

- (NSString *)stringRepresentation {
    NSString *cell = @" X ";
    if (self.content == EnumSymbolEmpty) {
        cell = @"   ";
    }
    else if (self.content == EnumSymbolO) {
        cell = @" O ";
    }
    return cell;
}

@end
