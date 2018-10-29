//
//  ImagePreviewViewController.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 16.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import "SingleImageViewController.h"

#import "ImagesTableViewDataSource.h"
#import "TabsCollectionViewDataSource.h"

#import "TabsCollectionViewCell.h"

#import "Constants.h"
#import "Utilities.h"

@interface ImagePreviewViewController ()

@property (weak, nonatomic) IBOutlet UITableView *imagesTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *tabsCollectionView;

@property (strong, nonatomic) ImagesTableViewDataSource *imagesDataSource;
@property (strong, nonatomic) TabsCollectionViewDataSource *tabDataSource;

@property (strong, nonatomic) TabsCollectionViewCell *selectedTab;
@property (strong, nonatomic) UIActivityIndicatorView *activityIandicatorView;

@end

@implementation ImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTabsCollection];
    [self configImagesTable];
    
    [self addActivityIndicatorToFooterView];
    [self addRefreshControl];
    
    [self addSwipeGestureRecognizers];
}

- (void)viewDidAppear:(BOOL)animated {
    [self collectionView:self.tabsCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
}

- (void)configTabsCollection {
    self.tabDataSource = [TabsCollectionViewDataSource newDataSource];
    self.tabsCollectionView.dataSource = self.tabDataSource;
    
    [self.tabsCollectionView setPagingEnabled:YES];
    [self.tabsCollectionView setShowsHorizontalScrollIndicator:NO];

    self.tabsCollectionView.delegate = self;
}

- (void)configImagesTable {
    self.imagesDataSource = [ImagesTableViewDataSource newDataSource];
    self.imagesTableView.dataSource = self.imagesDataSource;
    self.imagesTableView.delegate = self;
}

- (BOOL)shouldLoadNewDataForScrollView:(UIScrollView *)scrollView {
    if (![self.imagesDataSource isDataSourceLocal] && [scrollView isEqual:self.imagesTableView]) {
        return scrollView.contentOffset.y > self.imagesTableView.contentSize.height - self.imagesTableView.bounds.size.height;
    }
    return false;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self shouldLoadNewDataForScrollView:scrollView] && [scrollView isDragging]) {
        [self.activityIandicatorView startAnimating];
        [self.imagesDataSource addImageURLsWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imagesTableView reloadData];
                [self.activityIandicatorView stopAnimating];
            });
        }];
    }
}

- (void)addActivityIndicatorToFooterView {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setHidesWhenStopped:YES];
    activityIndicator.frame = CGRectMake(0, 0, self.imagesTableView.frame.size.width, 60);
    
    self.activityIandicatorView = activityIndicator;
    
    [self.imagesTableView setTableFooterView:self.activityIandicatorView];
}

- (void)addRefreshControl {
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshTableViewData:) forControlEvents:UIControlEventValueChanged];
    [self.imagesTableView insertSubview:refreshControl atIndex:0];
    self.imagesTableView.refreshControl = refreshControl;
}

- (void)addSwipeGestureRecognizers {
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipeWithGestureRecognizer:)];
    leftSwipeRecognizer.delegate = self;
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imagesTableView addGestureRecognizer:leftSwipeRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipeWithGestureRecognizer:)];
    rightSwipeRecognizer.delegate = self;
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imagesTableView addGestureRecognizer:rightSwipeRecognizer];
}

- (void)handleLeftSwipeWithGestureRecognizer:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:[self.tabsCollectionView indexPathForCell:self.selectedTab].item + 1 inSection:0];
        if (nextIndex && nextIndex.item >= 0 && nextIndex.item<= [self.tabsCollectionView numberOfItemsInSection:0]) {
                [self collectionView:self.tabsCollectionView didSelectItemAtIndexPath:nextIndex];
        }
    }
}

- (void)handleRightSwipeWithGestureRecognizer:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:[self.tabsCollectionView indexPathForCell:self.selectedTab].item - 1 inSection:0];
        if (nextIndex && nextIndex.item >= 0 && nextIndex.item<= [self.tabsCollectionView numberOfItemsInSection:0]) {
            [self collectionView:self.tabsCollectionView didSelectItemAtIndexPath:nextIndex];
        }
    }
}

- (void)refreshTableViewData:(UIRefreshControl *)refreshControl {
    [self.imagesDataSource refreshDataWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imagesTableView reloadData];
            [self.imagesTableView.refreshControl endRefreshing];
        });
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedTab.backgroundColor = UIColor.clearColor;
    self.selectedTab = (TabsCollectionViewCell *)[self.tabsCollectionView cellForItemAtIndexPath:indexPath];
    self.selectedTab.backgroundColor = UIColor.lightGrayColor;
    
    if ([self.selectedTab.title.text isEqualToString:@"YOUR IMAGES"]) { ///////////////////////////////////////////////
        [self.imagesDataSource loadLocallyStoredDataWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imagesTableView reloadData];
            });
        }];
    }
    else {
        [self.imagesDataSource loadDataSortedBy:[self stringToEnum:self.selectedTab.title.text] withCompletionHnadler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imagesTableView reloadData];
            });
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleImageViewController *imageViewController = (SingleImageViewController *)[Utilities viewControllerWithClass:SingleImageViewController.class];
    imageViewController.image = [self.imagesDataSource imageAtIndex:indexPath.row];
    imageViewController.imageURL = [self.imagesDataSource localURLAtIndex:indexPath.row];
    
    [self presentViewController:imageViewController animated:YES completion:nil];
}

- (ImagesSort)stringToEnum:(NSString *)string { ///todo
    if ([string isEqualToString:@"VIRAL"]) {
        return ImagesSortViral;
    }
    else if ([string isEqualToString:@"TOP"]) {
        return ImagesSortTop;
    }
    return ImagesSortDate;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.imagesTableView reloadData];
}

@end


