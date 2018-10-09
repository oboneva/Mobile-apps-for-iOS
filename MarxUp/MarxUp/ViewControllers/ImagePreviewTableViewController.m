//
//  ImagePreviewTableViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 8.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ImagePreviewTableViewController.h"
#import "ImageDataRequester.h"
#import "Constants.h"
#import "ImagePreviewTableViewCell.h"

@interface ImagePreviewTableViewController ()

@property (strong, nonatomic) ImageDataRequester *dataRequester;
@property (strong, nonatomic) NSMutableArray<NSString *> *data;
@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) NSMutableArray<NSString *> *invalidData;

@end

@implementation ImagePreviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [NSMutableArray new];
    self.imageCache = [NSCache new];
    self.dataRequester = [ImageDataRequester newRequester];
    [self.dataRequester getImageLinksWithCompletionHandler:^(NSArray<NSString *> * _Nonnull imageLinks) {
        [self.data addObjectsFromArray:imageLinks];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.data removeObjectsInArray:self.invalidData];
            [self.invalidData removeAllObjects];
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImagePreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_IMAGE_PREVIEW_CELL forIndexPath:indexPath];
    UIImage *image = [self.imageCache objectForKey:self.data[indexPath.row]];
    
    if (!image) {
        [self.dataRequester getImageDataWithLink:self.data[indexPath.row] andCompletionHandler:^(NSData * _Nonnull data) {
            UIImage *loadedImage = [UIImage imageWithData:data];
            [self addImage:loadedImage toCacheWithKey:self.data[indexPath.row]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.backgroundColor = UIColor.lightGrayColor;
                cell.urlImageView.layer.borderColor = UIColor.orangeColor.CGColor;
                cell.urlImageView.layer.borderWidth = 2;
                cell.urlImageView.image = loadedImage;
            });
        }];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.backgroundColor = UIColor.lightGrayColor;
            cell.urlImageView.layer.borderColor = UIColor.orangeColor.CGColor;
            cell.urlImageView.layer.borderWidth = 2;
            cell.urlImageView.image = image;
        });
    }
    
    return cell;
}

- (void)addImage:(UIImage *)image toCacheWithKey:(NSString *)key {
    if (image) {
        [self.imageCache setObject:image forKey:key];
    }
    else {
        [self.invalidData addObject:key];
    }
}

- (BOOL)shouldLoadNewDataForScrollView:(UIScrollView *)scrollView {
    return scrollView.contentOffset.y > self.tableView.contentSize.height - self.tableView.bounds.size.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.dataRequester.areImageIDsLoading && [self shouldLoadNewDataForScrollView:scrollView] && [scrollView isDragging]) {
        [self.dataRequester getImageLinksWithCompletionHandler:^(NSArray<NSString *> * _Nonnull imageIDs) {
            [self.data addObjectsFromArray:imageIDs];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.data removeObjectsInArray:self.invalidData];
                [self.invalidData removeAllObjects];
                [self.tableView reloadData];
            });
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

@end
