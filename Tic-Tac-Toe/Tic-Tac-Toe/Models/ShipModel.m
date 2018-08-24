//
//  ShipModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 21.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UITableView.h>
#import "ShipModel.h"

@interface ShipModel ()
@property (assign)int hitCount;

@end


@implementation ShipModel

+ (instancetype)newShipWithName:(NSString *)name andSize:(int)size{
    ShipModel *newShip = [[ShipModel alloc] init];
    if (newShip) {
        newShip.size = size;
        newShip.name = name;
        newShip.hitCount = 0;
    }
    return newShip;
}

- (void)hit {
    self.hitCount++;
}

- (BOOL)hasSunk {
    return self.hitCount == self.size;
}

- (BOOL)isCellAtIndexPathPartOfThisShip:(NSIndexPath *)indexPath {
    return (indexPath.section == self.head.section && indexPath.item >= self.head.item && indexPath.item <= self.tail.item) ||
    (indexPath.item == self.head.item && indexPath.section >= self.head.section && indexPath.section <= self.tail.section);
}

@end

