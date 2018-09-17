//
//  BoardCollectionViewDataSourceDelegate.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 14.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "BoardCollectionViewDataSourceDelegate.h"

#import "GameCell.h"

#import "BoardModel.h"
#import "DraggedShipModel.h"
#import "ShipModel.h"

#import "Constants.h"
#import "Utilities.h"


#define BOARD_SECTION_COUNT 10;
#define BOARD_ITEMS_COUNT   10;

@implementation BoardCollectionViewDataSourceDelegate

+ (instancetype)dataSource {
    BoardCollectionViewDataSourceDelegate *newDataSource = [BoardCollectionViewDataSourceDelegate new];
    return newDataSource;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.board.rows;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.board.columns;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GameCell *gameCell = (GameCell *)[collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_GAME_CELL forIndexPath:indexPath];
    
    gameCell.contentLabel.text = @"";
    [self setBackgroundColorToCell:gameCell atIndexPath:indexPath];
    gameCell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    gameCell.contentView.layer.borderWidth = 1.0;
    
    return gameCell;
}

- (void)setBackgroundColorToCell:(GameCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if ([self isCellAtIndexPathOccupied:indexPath]) {
        if (self.draggedShip.currentIndexesAreValid) {
            cell.backgroundColor = [UIColor greenColor];
        }
        else {
            cell.backgroundColor = [UIColor redColor];
        }
    }
    else if ([self.board shipAtIndexPath:indexPath]) {
        cell.backgroundColor = [Utilities colorForShipWithName:[self.board shipAtIndexPath:indexPath].name];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (BOOL)isCellAtIndexPathOccupied:(NSIndexPath *)indexPath {
    return indexPath >= self.draggedShip.currentHeadIndex && indexPath <= self.draggedShip.currentTailIndex;
}

@end
