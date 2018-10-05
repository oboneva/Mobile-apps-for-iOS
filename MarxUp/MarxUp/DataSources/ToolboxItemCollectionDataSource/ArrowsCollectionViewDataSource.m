//
//  ArrowsCollectionViewDataSource.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ArrowsCollectionViewDataSource.h"
#import "ToolboxItemOptionsCollectionViewCell.h"
#import "ArrowModel.h"
#import "Constants.h"


@interface ArrowsCollectionViewDataSource ()

@property (strong, nonatomic)NSArray<ArrowModel *> *arrows;

@end

@implementation ArrowsCollectionViewDataSource


+ (instancetype)newDataSource {
    ArrowsCollectionViewDataSource *newDataSource = [ArrowsCollectionViewDataSource new];
    
    ArrowModel *openArrow = [ArrowModel newArrowFromType:ArrowEndLineTypeOpen];
    ArrowModel *closedArrow = [ArrowModel newArrowFromType:ArrowEndLineTypeClosed];
    newDataSource.arrows = @[openArrow, closedArrow];
    
    return newDataSource;
}

- (ArrowEndLineType)optionAtIndex:(NSInteger)index {
    return self.arrows[index].type;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ToolboxItemOptionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_TOOLBOX_ITEM_OPTIONS_CELL forIndexPath:indexPath];
    ArrowModel *model = self.arrows[indexPath.item];
    
    cell.imageView.image = model.image;
    
    return cell;
}

@end
