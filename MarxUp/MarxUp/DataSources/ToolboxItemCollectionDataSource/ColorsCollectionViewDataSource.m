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
    UIColor *color1 = [UIColor colorWithRed:1 green:0.5411764706 blue:0.5019607843 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:0.9176470588 green:0.5019607843 blue:0.9882352941 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:1 green:1 blue:0.5529411765 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:0.7254901961 green:0.9647058824 blue:0.7921568627 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:0.7019607843 green:0.5333333333 blue:1 alpha:1];
    UIColor *color6 = [UIColor colorWithRed:1 green:0.8196078431 blue:0.5019607843 alpha:1];
    UIColor *color7 = [UIColor colorWithRed:0.5490196078 green:0.6196078431 blue:1 alpha:1];
    UIColor *color8 = [UIColor colorWithRed:1 green:0.6196078431 blue:0.5019607843 alpha:1];
    UIColor *color9 = [UIColor colorWithRed:0.5019607843 green:0.8470588235 blue:1 alpha:1];
    UIColor *color10 = [UIColor colorWithRed:0.737254902 green:0.6666666667 blue:0.6431372549 alpha:1];
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

- (UIColor *)optionAtIndex:(NSInteger)index {
    return self.colors[index];
}

@end
