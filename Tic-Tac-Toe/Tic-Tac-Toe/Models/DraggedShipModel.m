//
//  DraggedShipModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 28.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "DraggedShipModel.h"

@implementation DraggedShipModel

+ (instancetype)newWithShip:(ShipModel *)ship andCell:(ShipCell *)cell{
    DraggedShipModel *new = [[DraggedShipModel alloc] init];
    if (new) {
        new.ship = ship;
        new.cell = cell;
        new.orientation = EnumOrientationHorizontal;
    }
    return new;
}

- (void)resetOccupiedIndexes {
    self.currentHeadIndex = nil;
    self.currentTailIndex = nil;
}

@end
