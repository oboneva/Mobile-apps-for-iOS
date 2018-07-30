//
//  MatrixCollectionViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "MatrixCollectionViewController.h"
#import "AppDelegate.h"

#import "GameEngine.h"
#import "TunakTunakTunEngine.h"
#import "GameCell.h"

#import "GameCellModel.h"
#import "TicTacToeCellModel.h"
#import "TunakTunakTunCellModel.h"
#import "PlayerModel.h"

#import "Constants.h"
#import "Protocols.h"

#import "GameViewController.h"

@interface MatrixCollectionViewController ()

@property (strong, nonatomic) PlayerModel *player1;
@property (strong, nonatomic) PlayerModel *player2;
@property (strong, nonatomic) NSArray<NSString *> *colourImageNames;

- (void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation MatrixCollectionViewController

static NSString * const reuseIdentifier = IDENTIFIER_GAME_CELL;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setAllowsMultipleSelection:NO];
    self.engine.notifyPlayerToPlayDelegate = self.notifyPlayerToPlayDelegate;
    self.engine.endGameDelegate = self.endGameDelegate;
    //[self.engine setUpPlayers];
    
    self.colourImageNames = @[@"tunak_yellow.jpg", @"tunak_green.jpg", @"tunak_red.png"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataWithNotification:) name:NOTIFICATION_RECEIVE_DATA object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.engine newGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.engine rowsCount];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.engine itemsCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    GameCellModel *model = [self.engine getCellAtIndex:indexPath];
    
    [self setTextColourFromModel:model toCell:cell];
    [self setTextFromEnum:model.content toCell:cell];

    return cell;
}

- (void)setTextColourFromModel:(GameCellModel *)model toCell:(GameCell *)cell {
    if ([self.engine isMemberOfClass:TunakTunakTunEngine.class]) {
        TunakTunakTunCellModel *tempCell = (TunakTunakTunCellModel *)model;
        if (tempCell.colour > EnumColourClear) {
            [cell.backgroundView setHidden:NO];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.colourImageNames[(int)tempCell.colour - 1]]];
            cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
            cell.contentView.layer.borderWidth = 1.0;
        }
        else {
            [cell.backgroundView setHidden:YES];
            cell.contentView.layer.borderWidth = 0.0;
        }
    }
}

- (void)setTextFromEnum:(EnumCell)text toCell:(GameCell *)cell {
    cell.contentLabel.text = EMPTY_CELL;
    if (text == EnumCellWithO) {
        cell.contentLabel.text = @"O";
    }
    else if (text == EnumCellWithX) {
        cell.contentLabel.text = @"X";
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat size  = self.view.frame.size.width;
    if (size > self.view.frame.size.height) {
        size = self.view.frame.size.height;
    }
    return CGSizeMake(size * 0.3 - 5, size * 0.3 - 5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 5, 0, 0);
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL iAmOnTurn = true;
    if (self.gameMode == EnumGameModeTwoDevices) {
        iAmOnTurn = [self.engine.currentPlayer isEqual:self.engine.player1];  // the other player is always player2
    }
    return [self.engine isCellAtIndexPathSelectable:indexPath] && iAmOnTurn;
}

-(EnumGameMode) gameMode
{
    return ((GameViewController *)self.parentViewController).gameMode;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameMode == EnumGameModeTwoDevices) {
            [self sendCellMarkedAtIndexPath:indexPath];
    }
    [self.engine playerSelectedItemAtIndexPath:indexPath];
    [self.collectionView reloadData];
}

- (void)sendCellMarkedAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringData = [NSString stringWithFormat:@"%d,%d", (int)indexPath.section, (int)indexPath.row];
    NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *peers = @[self.peer];
    NSError *error;
    
    [MultipeerConectivityManager.sharedInstance.session sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:&
     error];
}

- (void)didReceiveDataWithNotification:(NSNotification *)notification {
    NSData *data = [[notification userInfo] objectForKey:@"data"];
    NSString *cellCoordinates = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSInteger section = [[cellCoordinates substringFromIndex:0] intValue];
    NSInteger row = [[cellCoordinates substringFromIndex:2] intValue];
    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self.engine playerSelectedItemAtIndexPath:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

@end
