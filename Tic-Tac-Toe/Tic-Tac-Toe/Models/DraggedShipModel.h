//
//  DraggedShipModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 28.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class ShipCell;
@class ShipModel;
@interface DraggedShipModel : NSObject

+ (instancetype)newWithShip:(ShipModel *)ship andImageView:(UIImageView *)imageView;
- (void)resetOccupiedIndexes;

@property (strong, nonatomic) ShipModel *ship;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign) EnumOrientation orientation;

@property (strong, nonatomic) NSIndexPath *currentHeadIndex;
@property (strong, nonatomic) NSIndexPath *currentTailIndex;
@property (strong, nonatomic) NSIndexPath *previousHeadIndex;

@property (assign) BOOL currentIndexesAreValid;

@end
