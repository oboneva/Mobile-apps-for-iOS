//
//  BoardCollectionViewDataSourceDelegate.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 14.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BoardModel;
@class DraggedShipModel;

@interface BoardCollectionViewDataSourceDelegate : NSObject <UICollectionViewDataSource>

+ (instancetype)dataSource;
@property (strong, nonatomic) BoardModel *board;
@property (strong, nonatomic) DraggedShipModel* draggedShip;

@end
