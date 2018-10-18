//
//  ImagesTableViewDataSource.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 16.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@class ImageDataRequester;

NS_ASSUME_NONNULL_BEGIN

@interface ImagesTableViewDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) ImageDataRequester *dataRequester;
+ (instancetype)newDataSource;
- (void)addImageURLsWithCompletionHandler:(void(^)(void))handler;
- (void)refreshDataWithCompletionHandler:(void(^)(void))handler;
- (void)loadDataSortedBy:(ImagesSort)sort withCompletionHnadler:(void(^)(void))handler;

@end

NS_ASSUME_NONNULL_END