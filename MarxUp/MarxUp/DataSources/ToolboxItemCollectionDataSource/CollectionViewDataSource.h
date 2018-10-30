//
//  CollectionViewDataSource.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 26.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewDataSource : NSObject <UICollectionViewDataSource>

- (NSInteger)optionAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
