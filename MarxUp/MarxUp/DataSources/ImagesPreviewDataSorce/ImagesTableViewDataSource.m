//
//  ImagesTableViewDataSource.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 16.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImagesTableViewDataSource.h"

#import "ImagePreviewTableViewCell.h"

#import "ImageDataRequester.h"
#import "FileManager.h"

#import "Constants.h"

@interface ImagesTableViewDataSource ()

@property (strong, nonatomic) NSMutableArray<NSString *> *imageURLs;
@property (strong, nonatomic) NSMutableArray<NSString *> *invalidImageURLs;
@property (strong, nonatomic) NSCache *imageCache;
@property (assign) ImagesSort sort;

@property (assign) BOOL dataIsStoredLocally;

@end


@implementation ImagesTableViewDataSource

+ (instancetype)newDataSource {
    ImagesTableViewDataSource *new = [ImagesTableViewDataSource new];
    
    new.imageURLs = [NSMutableArray new];
    new.imageCache = [NSCache new];
    new.dataRequester = [ImageDataRequester newRequester];
    
    new.dataIsStoredLocally = false;
    
    return new;
}

- (void)loadDataSortedBy:(ImagesSort)sort withCompletionHandler:(void(^)(void))handler {
    self.dataIsStoredLocally = false;
    self.sort = sort;

    [self.dataRequester cancelCurrentRequestsWithCompletionHandler:^{
        [self.imageURLs removeAllObjects];
        [self.dataRequester getImageLinksSortedBy:sort withCompletionHandler:^(NSArray<NSString *> * _Nonnull imageIDs) {
            if (imageIDs) {
                [self.imageURLs addObjectsFromArray:imageIDs];
            }
            handler();
        }];
    }];
}

- (void)loadLocallyStoredDataWithCompletionHandler:(void(^)(void))handler {
    self.dataIsStoredLocally = true;
    self.imageURLs = [FileManager loadDocumentsOfType:@"png"].mutableCopy;
    handler();
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImagePreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_IMAGE_PREVIEW_CELL forIndexPath:indexPath];
    cell.urlImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage *image = [self.imageCache objectForKey:self.imageURLs[indexPath.row]];
    
    if (image) {
        [self setImage:image toCell:cell];
    }
    else if(self.dataIsStoredLocally) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.imageURLs[indexPath.row]]];
        [self setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]] toCell:cell];
    }
    else {
        [self tableView:tableView loadPictureForCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (void)setImage:(UIImage *)image toCell:(ImagePreviewTableViewCell *)cell {
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.urlImageView.image = image;
    });
}

- (void)setUIToCell:(ImagePreviewTableViewCell *)cell {
//    cell.urlImageView.layer.borderColor = UIColor.orangeColor.CGColor;
//    cell.urlImageView.layer.borderWidth = 2;
}

- (void)tableView:(UITableView *)tableView loadPictureForCell:(ImagePreviewTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
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

- (void)addImage:(UIImage *)image toCacheWithKey:(NSString *)key {
    if (image) {
        [self.imageCache setObject:image forKey:key];
    }
    else {
        [self.invalidImageURLs addObject:key];
    }
}

- (void)addImageURLsWithCompletionHandler:(void(^)(void))handler {
    [self.dataRequester cancelCurrentRequestsWithCompletionHandler:^{
        if (self.dataIsStoredLocally) {
            handler();
        }
        else {
            [self.dataRequester getImageLinksSortedBy:self.sort withCompletionHandler:^(NSArray<NSString *> * _Nonnull imageIDs) {
                if (imageIDs) {
                    [self.imageURLs addObjectsFromArray:imageIDs];
                    [self.imageURLs removeObjectsInArray:self.invalidImageURLs];
                    [self.invalidImageURLs removeAllObjects];
                }
                handler();
            }];
        }
    }];
}

- (void)refreshDataWithCompletionHandler:(void(^)(void))handler {//////////////////////////////////////////
    [self.dataRequester cancelCurrentRequestsWithCompletionHandler:^{
        if (self.dataIsStoredLocally) {
            handler();
        }
        else {
            [self.dataRequester getImageLinksSortedBy:self.sort withCompletionHandler:^(NSArray<NSString *> * _Nonnull imageIDs) {
                if (imageIDs) {
                    [self.imageURLs removeAllObjects];
                    [self.invalidImageURLs removeAllObjects];
                    [self.imageURLs addObjectsFromArray:imageIDs];
                }
                handler();
            }];
        }
    }];
}

- (UIImage *)imageAtIndex:(NSInteger)index {
    if (self.dataIsStoredLocally) {
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.imageURLs[index]]]]];
    }
    return [self.imageCache objectForKey:self.imageURLs[index]];
}

- (NSURL *)URLAtIndex:(NSInteger)index {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.imageURLs[index]]];
}

- (NSURL *)localURLAtIndex:(NSInteger)index {
    if (self.dataIsStoredLocally) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.imageURLs[index]]];
    }
    return (NSURL *)nil;
}

- (BOOL)isDataSourceLocal {
    return self.dataIsStoredLocally;
}

@end
