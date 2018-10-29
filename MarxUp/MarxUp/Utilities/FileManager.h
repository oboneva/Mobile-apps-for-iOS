//
//  FileManager.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 12.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileManager : NSObject

+ (NSArray<NSURL *> *)loadDocumentsOfType:(NSString *)type;
+ (void)copyURLToDocuments:(NSURL *)url;
+ (void)saveImage:(NSData *)imageData atImageURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
