//
//  MatrixCollectionViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "MatrixCollectionViewController.h"

#import "GameCell.h"

#import "GameCellModel.h"
#import "TunakTunakTunCellModel.h"
#import "PlayerModel.h"

@interface MatrixCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSArray<NSString *> *colourImageNames;

@end

@implementation MatrixCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setAllowsMultipleSelection:NO];
    self.colourImageNames = @[@"tunak_yellow.jpg", @"tunak_green.jpg", @"tunak_red.png"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.engineDelegate startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.engineDelegate rowsCount];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.engineDelegate itemsCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_GAME_CELL forIndexPath:indexPath];
    GameCellModel *model = [self.engineDelegate getCellAtIndex:indexPath];
    
    [self setTextFromEnum:model.content toCell:cell];
    if ([self.engineDelegate getGameType] == EnumGameTunakTunakTun) {
        [self setTextColourFromModel:model toCell:cell];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)setTextColourFromModel:(GameCellModel *)model toCell:(GameCell *)cell {
    TunakTunakTunCellModel* tempCell = (TunakTunakTunCellModel *)model;
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

- (void)setTextFromEnum:(EnumCell)text toCell:(GameCell *)cell {
    cell.contentLabel.text = EMPTY_CELL;
    if (text == EnumCellWithO) {
        cell.contentLabel.text = @"O";
    }
    else if (text == EnumCellWithX) {
        cell.contentLabel.text = @"X";
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL iAmOnTurn = true;
    if ([self.engineDelegate getGameMode] == EnumGameModeTwoDevices) {
        iAmOnTurn = [self.engineDelegate.currentPlayer isEqual:self.engineDelegate.player1];  // the other player is always player2
    }
    return [self.engineDelegate isCellAtIndexPathSelectable:indexPath] && iAmOnTurn;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (self.engineDelegate.gameMode == EnumGameModeTwoDevices) {
        [self.engineDelegate sendCellMarkedAtIndexPath:indexPath];// TODO: Transform to 'Mother, someone touched me at indexPath'
    }
     */
    [self.engineDelegate playerSelectedItemAtIndexPath:indexPath];
    [self.collectionView reloadData];
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

@end
