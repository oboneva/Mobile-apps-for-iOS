//
//  TunakTunakTunCellModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 24.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "TunakTunakTunCellModel.h"

#import "Constants.h"

@implementation TunakTunakTunCellModel

+ (instancetype)customCellWithColor:(EnumColor)color {
    TunakTunakTunCellModel *newCell = [[TunakTunakTunCellModel alloc] init];
    if (newCell) {
        newCell.content = TUNAK_TUNAK_TUN_SYMBOL;
        newCell.color = color;
    }
    return newCell;
}

+ (instancetype)emptyCell {
    TunakTunakTunCellModel *newCell = [[TunakTunakTunCellModel alloc] init];
    if (newCell) {
        newCell.content = TUNAK_TUNAK_TUN_SYMBOL;
        newCell.color = EnumColorClear;
    }
    return newCell;
}

- (BOOL)isEqualToCell:(TunakTunakTunCellModel *)other {
    return self.color == other.color;
}

- (void)clearCell {
    self.color = EnumColorClear;
}

- (BOOL)isSelectable {
    return self.color != LAST_COLOR;
}

- (BOOL)isEmpty {
    return self.color == EnumColorClear;
}

- (NSString *)stringRepresentation {
    NSString *cell = @" Y ";
    if (self.color == EnumColorRed) {
        cell = @" R ";
    }
    else if (self.color == EnumColorClear) {
        cell = @"   ";
    }
    else if (self.color == EnumColorGreen) {
        cell = @" G ";
    }
    return cell;
}

@end
