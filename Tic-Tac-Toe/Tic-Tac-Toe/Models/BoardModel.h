//
//  BoardModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 21.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BattleshipsCellModel;
@class ShipModel;

@interface BoardModel : NSObject

@property (strong, nonatomic)NSArray<NSArray<BattleshipsCellModel *> *> *gameMatrix;
@property (strong, nonatomic)NSArray<ShipModel *> *ships;
@property (assign)int rows;
@property (assign)int columns;
@property (assign) int filled_cells;

+ (instancetype)newBoardWithCellType:(Class)cellType rows:(int)rowsCount andColumns:(int)columnsCount;

- (BOOL)isCellAtIndexPathPartOfShip:(NSIndexPath *)indexPath;
- (BOOL)playerOnThisBoardLost;
- (NSArray<NSIndexPath *> *)availableCellsForShip;
- (ShipModel *)shipAtIndexPath:(NSIndexPath *)indexPath;
- (void)clearBoard;
- (void)randomArrangeShips;

@end
