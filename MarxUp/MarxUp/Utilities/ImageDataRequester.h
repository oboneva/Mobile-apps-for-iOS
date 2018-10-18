//
//  ImageDataRequester.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 8.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageDataRequester : NSObject

+ (instancetype)newRequester;

- (void)getImageDataWithLink:(NSString *)imageLink andCompletionHandler:(void(^)(NSData *))handler;
- (void)getImageLinksSortedBy:(ImagesSort)sort withCompletionHandler:(void(^)(NSArray<NSString *> *))handler;

@end

NS_ASSUME_NONNULL_END
