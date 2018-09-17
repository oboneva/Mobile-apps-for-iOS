//
//  DraggedShipModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 28.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "DraggedShipModel.h"
#import "ShipModel.h"
#import "Utilities.h"

@implementation DraggedShipModel

+ (instancetype)newWithShip:(ShipModel *)ship andImageView:(UIImageView *)imageView{
    DraggedShipModel *new = [[DraggedShipModel alloc] init];
    if (new) {
        new.ship = ship;
        new.orientation = EnumOrientationHorizontal;
        new.imageView = [UIImageView new];
        new.imageView.backgroundColor = [Utilities colorForShipWithName:ship.name];
        new.imageView.frame = imageView.frame; //for size
    }
    return new;
}

- (void)resetOccupiedIndexes {
    self.currentHeadIndex = nil;
    self.currentTailIndex = nil;
}

@end
