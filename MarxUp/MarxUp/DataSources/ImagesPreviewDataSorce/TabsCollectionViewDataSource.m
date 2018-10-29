//
//  TabsCollectionViewDataSource.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 16.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "TabsCollectionViewDataSource.h"
#import "TabsCollectionViewCell.h"
#import "Constants.h"

@interface TabsCollectionViewDataSource ()

@property (strong, nonatomic) NSArray<NSString *> *tabs;

@end


@implementation TabsCollectionViewDataSource

+ (instancetype)newDataSource {
    TabsCollectionViewDataSource *newDataSource = [TabsCollectionViewDataSource new];
    newDataSource.tabs = @[@"TOP", @"VIRAL", @"LATEST", @"YOUR IMAGES"];
    return newDataSource;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tabs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TabsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_TABS_CELL forIndexPath:indexPath];
    cell.title.text = self.tabs[indexPath.item];
    cell.title.textColor = UIColor.orangeColor;
    return cell;
}

- (NSString *)tabAtIndex:(NSInteger)index {
    return self.tabs[index];
}

@end
