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

@property (assign) NSInteger selectedTabIndex;
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
    if (!self.selectedTabIndex) {
        [self collectionView:self.tabsCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    }
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
        
        __weak __typeof__(self) weakSelf = self;
        [self.imagesDataSource addImageURLsWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.imagesTableView reloadData];
                [weakSelf.activityIandicatorView stopAnimating];
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
        NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:self.selectedTabIndex + 1 inSection:0];
        if (nextIndex && nextIndex.item >= 0 && nextIndex.item<= [self.tabsCollectionView numberOfItemsInSection:0]) {
                [self collectionView:self.tabsCollectionView didSelectItemAtIndexPath:nextIndex];
        }
    }
}

- (void)handleRightSwipeWithGestureRecognizer:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:self.selectedTabIndex - 1 inSection:0];
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
    TabsCollectionViewCell *previousSelected = (TabsCollectionViewCell *)[self.tabsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedTabIndex inSection:0]];
    previousSelected.backgroundColor = UIColor.clearColor;
    TabsCollectionViewCell *currentSelected = (TabsCollectionViewCell *)[self.tabsCollectionView cellForItemAtIndexPath:indexPath];
    currentSelected.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.1];
    
    if ([currentSelected.title.text isEqualToString:@"YOUR IMAGES"]) { ///////////////////////////////////////////////
        [self.imagesDataSource loadLocallyStoredDataWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imagesTableView reloadData];
            });
        }];
    }
    else {
        [self.imagesDataSource loadDataSortedBy:[Utilities stringToEnum:currentSelected.title.text] withCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imagesTableView reloadData];
            });
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleImageViewController *imageViewController = (SingleImageViewController *)[Utilities viewControllerWithClass:SingleImageViewController.class];
    imageViewController.image = [self.imagesDataSource imageAtIndex:indexPath.row];
    imageViewController.imageLocalURL = [self.imagesDataSource localURLAtIndex:indexPath.row];
    imageViewController.imageURL = [self.imagesDataSource URLAtIndex:indexPath.row];
    
    [self presentViewController:imageViewController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.imagesTableView reloadData];
}

@end
