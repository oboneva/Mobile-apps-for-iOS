//
//  ImageDataRequester.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 8.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageDataRequester : NSObject

- (void)getImageLinksWithCompletionHandler:(void(^)(NSArray<NSString *> *))handler;
- (void)getImageDataWithLink:(NSString *)imageLink andCompletionHandler:(void(^)(NSData *))handler;
+ (instancetype)newRequester;

@end

NS_ASSUME_NONNULL_END
