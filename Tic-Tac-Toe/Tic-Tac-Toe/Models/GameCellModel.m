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
        newCell.content = EnumCellEmpty;
    }
    return newCell;
}

+ (instancetype)customCellWithContent:(EnumCell)content {
    GameCellModel *newCell = [[GameCellModel alloc] init];
    if (newCell) {
        newCell.content = content;
    }
    return newCell;
}

- (void)clearCell {
    self.content = EnumCellEmpty;
}

- (BOOL)isEqualToCell:(GameCellModel *)other {
    return self.content == other.content;
}

- (BOOL)isSelectable {
    return self.content == EnumCellEmpty;
}

- (BOOL)isEmpty {
    return [self isSelectable];
}

- (NSString *)stringRepresentation {
    NSString *cell = @" X ";
    if (self.content == EnumCellEmpty) {
        cell = @"   ";
    }
    else if (self.content == EnumCellWithO) {
        cell = @" O ";
    }
    return cell;
}

@end
