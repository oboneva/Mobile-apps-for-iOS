//
//  ColorsCollectionViewDataSource.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorsCollectionViewDataSource : CollectionViewDataSource

+ (instancetype)newDataSource;
- (UIColor *)optionAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END