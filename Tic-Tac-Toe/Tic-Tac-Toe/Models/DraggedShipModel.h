//
//  DraggedShipModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 28.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class ShipCell;
@class ShipModel;
@interface DraggedShipModel : NSObject

+ (instancetype)newWithShip:(ShipModel *)ship andCell:(ShipCell *)cell;

@property (strong, nonatomic) ShipCell *cell;
@property (strong, nonatomic) ShipModel *ship;
@property (assign) EnumOrientation orientation;
@property (strong, nonatomic) NSIndexPath *indexInAllShips;
@property (strong, nonatomic) NSIndexPath *currentHeadIndex;
@property (strong, nonatomic) NSIndexPath *currentTailIndex;

@end
