//
//  ImageDataRequester.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 8.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ImageDataRequester.h"

#define KEY_DATA               @"data"
#define KEY_IMAGES             @"images"
#define KEY_ID                 @"id"
#define KEY_LINK               @"link"
#define KEY_ANIMATED           @"animated"
#define SUFFIX_SMALL_THUMBNAIL @"t"

@interface ImageDataRequester ()

@property (strong, nonatomic)NSURL *url;
@property (strong, nonatomic)NSMutableURLRequest *request;
@property (strong, nonatomic)NSURLSession *session;
@property (assign)int page;


@end

@implementation ImageDataRequester

- (void)getImageLinksWithCompletionHandler:(void(^)(NSArray<NSString *> *))handler {
    self.areImageIDsLoading = TRUE;
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.imgur.com/3/gallery/hot/viral/day/%d?showViral=true&mature=false&album_previews=false", self.page]];
    [self updateRequest];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray<NSString *> *imageLinks = [self linksFromJSONDict:dataDict];
        self.areImageIDsLoading = FALSE;
        
        handler(imageLinks);
    }];
    [task resume];
    self.page++;
}

- (NSArray<NSString *> *)linksFromJSONDict:(NSDictionary *)dictionary {
    NSMutableArray<NSString *> *links = [NSMutableArray new];
    for (NSDictionary *dict in dictionary[KEY_DATA]) {
        NSDictionary *imageDictionary = [dict[KEY_IMAGES] firstObject];
        if (imageDictionary && [self shouldAddImageWithImageDictionary:imageDictionary]) {
            [links addObject:imageDictionary[KEY_LINK]];
        }
    }
    
    return links;
}

- (BOOL)shouldAddImageWithImageDictionary:(NSDictionary *)imageDictionary {
    return ![imageDictionary[KEY_ANIMATED] boolValue] &&
           ![imageDictionary[KEY_LINK] containsString:@"http:"];
}

- (void)getImageDataWithLink:(NSString *)imageLink andCompletionHandler:(void(^)(NSData *))handler {
    self.isImageDataLoading = TRUE;
    self.url = [NSURL URLWithString:[self URLStringForSmallThumbnailWithURLString:imageLink]];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:self.url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.isImageDataLoading = FALSE;
        handler(data);
    }];
    [task resume];
}

- (NSString *)URLStringForSmallThumbnailWithURLString:(NSString *)string {
    //NSArray<NSString *> *parts = [string componentsSeparatedByString:@"."];
    //NSString *imageID = [parts[2] componentsSeparatedByString:@"/"][1];
    return string;//[string stringByReplacingOccurrencesOfString:imageID withString:[imageID stringByAppendingString:SUFFIX_SMALL_THUMBNAIL]];
}

- (void)updateRequest {
    self.request = [NSMutableURLRequest requestWithURL:self.url];
    [self.request setHTTPMethod:@"GET"];
    [self.request addValue:@"Client-ID YOUR-ID" forHTTPHeaderField:@"Authorization"];
}

+ (instancetype)newRequester {
    ImageDataRequester *new = [ImageDataRequester new];
    new.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    new.page = 1;
    return new;
}

@end
