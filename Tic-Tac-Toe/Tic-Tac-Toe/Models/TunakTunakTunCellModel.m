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

+ (instancetype)customCellWithColour:(EnumColour)colour {
    TunakTunakTunCellModel *newCell = [[TunakTunakTunCellModel alloc] init];
    if (newCell) {
        newCell.content = TUNAK_TUNAK_TUN_SYMBOL;
        newCell.colour = colour;
    }
    return newCell;
}

+ (instancetype)emptyCell {
    TunakTunakTunCellModel *newCell = [[TunakTunakTunCellModel alloc] init];
    if (newCell) {
        newCell.content = TUNAK_TUNAK_TUN_SYMBOL;
        newCell.colour = EnumColourClear;
    }
    return newCell;
}

- (BOOL)isEqualToCell:(TunakTunakTunCellModel *)other {
    return self.colour == other.colour;
}

- (void)clearCell {
    self.colour = EnumColourClear;
}

- (BOOL)isSelectable {
    return self.colour != LAST_COLOUR;
}

- (BOOL)isEmpty {
    return self.colour == EnumColourClear;
}

- (NSString *)stringRepresentation {
    NSString *cell = @" Y ";
    if (self.colour == EnumColourRed) {
        cell = @" R ";
    }
    else if (self.colour == EnumColourClear) {
        cell = @"   ";
    }
    else if (self.colour == EnumColourGreen) {
        cell = @" G ";
    }
    return cell;
}

@end
