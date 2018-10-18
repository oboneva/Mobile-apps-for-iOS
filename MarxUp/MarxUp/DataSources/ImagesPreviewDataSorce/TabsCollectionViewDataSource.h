//
//  TabsCollectionViewDataSource.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 16.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabsCollectionViewDataSource : NSObject <UICollectionViewDataSource>

+ (instancetype)newDataSource;
- (NSString *)tabAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
