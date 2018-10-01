//
//  ShapesCollectionViewDataSource.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 26.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "CollectionViewDataSource.h"
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShapesCollectionViewDataSource : CollectionViewDataSource

+ (instancetype)newDataSource;
- (ShapeType)optionAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
