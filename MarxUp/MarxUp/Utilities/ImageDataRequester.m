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
@property (assign)ImagesSort sort;

@property (assign) BOOL areImageIDsLoading;

@end

@implementation ImageDataRequester

+ (instancetype)newRequester {
    ImageDataRequester *new = [ImageDataRequester new];
    new.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    new.page = 1;
    return new;
}

- (void)getImageLinksSortedBy:(ImagesSort)sort withCompletionHandler:(void(^)(NSArray<NSString *> *))handler {
    if (sort != self.sort) {
        self.page = 1;
        self.sort = sort;
    }
    
    self.areImageIDsLoading = TRUE;
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.imgur.com/3/gallery/hot/%@/day/%d?showViral=true&mature=false&album_previews=false", [self sortEnumToString:self.sort], self.page]];
    [self updateRequest];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray<NSString *> *imageLinks = nil;
        if ([dataDict[@"status"] intValue] == 200) {
            imageLinks = [self linksFromJSONDict:dataDict];
        }
        
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
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [self URLStringForSmallThumbnailWithURLString:imageLink]]];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:self.url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        handler(data);
    }];
    [task resume];
}

- (NSString *)URLStringForSmallThumbnailWithURLString:(NSString *)string {
    return string;
}

- (void)updateRequest {
    self.request = [NSMutableURLRequest requestWithURL:self.url];
    [self.request setHTTPMethod:@"GET"];
    [self.request addValue:@"Client-ID YOUR-ID" forHTTPHeaderField:@"Authorization"];
}

- (NSString *)sortEnumToString:(ImagesSort)sort {
    if (sort == ImagesSortViral) {
        return @"viral";
    }
    else if (sort == ImagesSortTop) {
        return @"top";
    }
    return @"time";
}

@end
