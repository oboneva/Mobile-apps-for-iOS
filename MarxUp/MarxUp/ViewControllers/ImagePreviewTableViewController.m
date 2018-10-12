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
@property (strong, nonatomic) NSMutableArray<NSString *> *imageURLs;
@property (strong, nonatomic) NSMutableArray<NSString *> *invalidImageURLs;
@property (strong, nonatomic) NSCache *imageCache;

@end

@implementation ImagePreviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageURLs = [NSMutableArray new];
    self.imageCache = [NSCache new];
    self.dataRequester = [ImageDataRequester newRequester];
    [self addImageURLs];
    [self addActivityIndicatorToFooterView];
    [self addRefreshControl];
}

#pragma mark - Table view data source

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
                cell.urlImageView.image = loadedImage;
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

- (void)addImage:(UIImage *)image toCacheWithKey:(NSString *)key {
    if (image) {
        [self.imageCache setObject:image forKey:key];
    }
    else {
        [self.invalidImageURLs addObject:key];
    }
}

- (BOOL)shouldLoadNewDataForScrollView:(UIScrollView *)scrollView {
    return scrollView.contentOffset.y > self.tableView.contentSize.height - self.tableView.bounds.size.height;// - 5 * self.tableView.rowHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self shouldLoadNewDataForScrollView:scrollView] && [scrollView isDragging]) {
        [self addImageURLs];
    }
}

- (void)addImageURLs {
    [self.dataRequester getImageLinksWithCompletionHandler:^(NSArray<NSString *> * _Nonnull imageIDs) {
        [self.imageURLs addObjectsFromArray:imageIDs];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageURLs removeObjectsInArray:self.invalidImageURLs];
            [self.invalidImageURLs removeAllObjects];
            [self.tableView reloadData];
        });
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (void)addActivityIndicatorToFooterView {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    activityIndicator.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60);
    [self.tableView setTableFooterView:activityIndicator];
}

- (void)setUIToCell:(ImagePreviewTableViewCell *)cell {
    cell.backgroundColor = UIColor.lightGrayColor;
    cell.urlImageView.layer.borderColor = UIColor.orangeColor.CGColor;
    cell.urlImageView.layer.borderWidth = 2;
}

- (void)addRefreshControl {
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshTableViewData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    self.tableView.refreshControl = refreshControl;
}

- (void)refreshTableViewData:(UIRefreshControl *)refreshControl {
    [self.dataRequester getImageLinksWithCompletionHandler:^(NSArray<NSString *> * _Nonnull imageIDs) {
        [self.imageURLs removeAllObjects];
        [self.invalidImageURLs removeAllObjects];
        
        [self.imageURLs addObjectsFromArray:imageIDs];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        });
    }];
}

@end
