//
//  ShipsCollectionViewDataSourceDelegate.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 14.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ShipsCollectionViewDataSourceDelegate.h"

#import "ShipModel.h"
#import "ShipCell.h"

#import "Utilities.h"
#import "Constants.h"

#define SHIPS_SECTION_COUNT 1;
#define BOARDER_WIDTH       1.0;

@interface ShipsCollectionViewDataSourceDelegate ()

@property (strong, nonatomic) NSArray<NSString *> *shipsNames;

@end

@implementation ShipsCollectionViewDataSourceDelegate

+ (instancetype)dataSource {
    ShipsCollectionViewDataSourceDelegate *newDataSource = [ShipsCollectionViewDataSourceDelegate new];
    if (newDataSource) {
        newDataSource.defaultShips = [Utilities getDefaultShips].mutableCopy;
        [newDataSource countShipUnits];
    }
    return newDataSource;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return SHIPS_SECTION_COUNT;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shipUnits.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShipCell *shipCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_SHIP_CELL forIndexPath:indexPath];
    ShipModel *ship = [self shipWithName:self.shipsNames[indexPath.item]];
    
    shipCell.nameLabel.text = ship.name;
    shipCell.sizeLabel.text = [NSString stringWithFormat:@"Size - %d", ship.size];
    shipCell.unitsLabel.text = [NSString stringWithFormat:@"x%@", self.shipUnits[ship.name]];
    shipCell.imageView.backgroundColor = [Utilities colorForShipWithName:ship.name];
    [self setSizeToImageView:shipCell.imageView withScaleFactor:ship.size];
    
    shipCell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    shipCell.contentView.layer.borderWidth = BOARDER_WIDTH;
    
    return shipCell;
}

//other methods

- (void)setSizeToImageView:(UIImageView *)image withScaleFactor:(int)num {
    NSLayoutConstraint *width = [image constraintForAttribute:NSLayoutAttributeWidth];
    width.constant = (self.boardCellSize - 5) * num;
    NSLayoutConstraint *height = [image constraintForAttribute:NSLayoutAttributeHeight];
    height.constant = self.boardCellSize;
}

- (void)countShipUnits {
    NSNumber *value;
    self.shipUnits = [NSMutableDictionary new];
    for (ShipModel *ship in self.defaultShips) {
        value = self.shipUnits[ship.name];
        if (value) {
            self.shipUnits[ship.name] = [NSNumber numberWithInt:[value intValue] + 1];
        }
        else {
            self.shipUnits[ship.name] = @1;
        }
    }
    self.shipsNames = self.shipUnits.allKeys;
}

- (ShipModel *)shipWithName:(NSString *)name {
    for (ShipModel * ship in self.defaultShips) {
        if ([ship.name isEqualToString:name]) {
            return ship;
        }
    }
    return (ShipModel *)nil;
}

@end
