//
//  ColorsCollectionViewDataSource.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ColorsCollectionViewDataSource.h"
#import "ToolboxItemOptionsCollectionViewCell.h"
#import "Constants.h"

@interface ColorsCollectionViewDataSource ()

@property (strong, nonatomic)NSArray<UIColor *> *colors;

@end

@implementation ColorsCollectionViewDataSource

+ (instancetype)newDataSource {
    ColorsCollectionViewDataSource *newDataSource = [ColorsCollectionViewDataSource new];
    UIColor *color1 = [UIColor blackColor];
    UIColor *color2 = [UIColor blueColor];
    UIColor *color3 = [UIColor redColor];
    UIColor *color4 = [UIColor orangeColor];
    UIColor *color5 = [UIColor yellowColor];
    UIColor *color6 = [UIColor whiteColor];
    UIColor *color7 = [UIColor greenColor];
    UIColor *color8 = [UIColor magentaColor];
    UIColor *color9 = [UIColor purpleColor];
    UIColor *color10 = [UIColor brownColor];
    newDataSource.colors = @[color1, color2, color3, color4, color5, color6, color7, color8, color9, color10];
    return newDataSource;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ToolboxItemOptionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_TOOLBOX_ITEM_OPTIONS_CELL forIndexPath:indexPath];
    
    cell.backgroundColor = self.colors[indexPath.item];
    
    return cell;
}

- (UIColor *)colorAtIndex:(NSInteger)index {
    return self.colors[index];
}

@end
