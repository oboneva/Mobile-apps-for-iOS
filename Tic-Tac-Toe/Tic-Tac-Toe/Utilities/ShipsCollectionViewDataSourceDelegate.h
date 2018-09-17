//
//  ShipsCollectionViewDataSourceDelegate.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 14.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShipModel;

@interface ShipsCollectionViewDataSourceDelegate : NSObject <UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber *> *shipUnits;
@property (strong, nonatomic) NSMutableArray<ShipModel *> *defaultShips;
@property (assign) double boardCellSize;

+ (instancetype)dataSource;
- (void)countShipUnits;
- (ShipModel *)shipWithName:(NSString *)name;

@end
