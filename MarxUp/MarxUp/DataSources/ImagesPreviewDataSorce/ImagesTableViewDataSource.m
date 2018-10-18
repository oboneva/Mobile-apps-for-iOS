//
//  ImagesTableViewDataSource.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 16.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesTableViewDataSource.h"
#import "ImageDataRequester.h"
#import "Constants.h"
#import "ImagePreviewTableViewCell.h"

@interface ImagesTableViewDataSource ()

@property (strong, nonatomic) NSMutableArray<NSString *> *imageURLs;
@property (strong, nonatomic) NSMutableArray<NSString *> *invalidImageURLs;
@property (strong, nonatomic) NSCache *imageCache;
@property (assign) ImagesSort sort;

@end


@implementation ImagesTableViewDataSource

+ (instancetype)newDataSource {
    ImagesTableViewDataSource *new = [ImagesTableViewDataSource new];
    
    new.imageURLs = [NSMutableArray new];
    new.imageCache = [NSCache new];
    new.dataRequester = [ImageDataRequester newRequester];
    
    return new;
}

- (void)loadDataSortedBy:(ImagesSort)sort withCompletionHnadler:(void(^)(void))handler {
    self.sort = sort;
    [self.dataRequester getImageLinksSortedBy:sort withCompletionHandler:^(NSArray<NSString *> * _Nonnull imageIDs) {
        if (imageIDs) {
            [self.imageURLs removeAllObjects];
            [self.imageURLs addObjectsFromArray:imageIDs];
        }
        handler();
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImagePreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_IMAGE_PREVIEW_CELL forIndexPath:indexPath];
    UIImage *image = [self.imageCache objectForKey:self.imageURLs[indexPath.row]];
    
    [self setUIToCell:cell];
    if (!image) {
        [self.dataRequester getImageDataWithLink:self.imageURLs[indexPath.row] andCompletionHandler:^(NSData * _Nonnull data) {
            UIImage *loadedImage = [UIImage imageWithData:data];
            [self addImage:loadedImage toCacheWithKey:self.imageURLs[indexPath.row]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([tableView.indexPathsForVisibleRows containsObject:indexPath]) {
                    cell.urlImageView.image = loadedImage;
                }
            });
        }];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.urlImageView.image = image;
        });
    }
    
    return cell;
}

- (void)setUIToCell:(ImagePreviewTableViewCell *)cell {
    cell.urlImageView.layer.borderColor = UIColor.orangeColor.CGColor;
    cell.urlImageView.layer.borderWidth = 2;
}

- (void)addImage:(UIImage *)image toCacheWithKey:(NSString *)key {
    if (image) {
        [self.imageCache setObject:image forKey:key];
    }
    else {
        [self.invalidImageURLs addObject:key];
    }
}

- (void)addImageURLsWithCompletionHandler:(void(^)(void))handler {
    [self.dataRequester getImageLinksSortedBy:self.sort withCompletionHandler:^(NSArray<NSString *> * _Nonnull imageIDs) {
        if (imageIDs) {
            [self.imageURLs addObjectsFromArray:imageIDs];
            [self.imageURLs removeObjectsInArray:self.invalidImageURLs];
            [self.invalidImageURLs removeAllObjects];
        }
        handler();
    }];
}

- (void)refreshDataWithCompletionHandler:(void(^)(void))handler {
    [self.dataRequester getImageLinksSortedBy:self.sort withCompletionHandler:^(NSArray<NSString *> * _Nonnull imageIDs) {
        if (imageIDs) {
            [self.imageURLs removeAllObjects];
            [self.invalidImageURLs removeAllObjects];
            [self.imageURLs addObjectsFromArray:imageIDs];
        }
        handler();
    }];
}

@end
