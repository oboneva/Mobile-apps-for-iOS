//
//  MatrixCollectionViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "MatrixCollectionViewController.h"

#import "GameEngine.h"
#import "TunakTunakTunEngine.h"
#import "GameCell.h"

#import "GameCellModel.h"
#import "TicTacToeCellModel.h"
#import "TunakTunakTunCellModel.h"
#import "PlayerModel.h"

#import "Constants.h"
#import "Protocols.h"

@interface MatrixCollectionViewController ()

@property (strong, nonatomic) PlayerModel *player1;
@property (strong, nonatomic) PlayerModel *player2;
@property (strong, nonatomic) NSArray<NSString *> *colourImageNames;

@end

@implementation MatrixCollectionViewController

static NSString * const reuseIdentifier = IDENTIFIER_GAME_CELL;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setAllowsMultipleSelection:NO];
    self.engine.notifyPlayerToPlayDelegate = self.notifyPlayerToPlayDelegate;
    self.engine.endGameDelegate = self.endGameDelegate;
    [self.engine setUpPlayers];
    
    self.colourImageNames = @[@"tunak_yellow.jpg", @"tunak_green.jpg", @"tunak_red.png"];
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
    return [self.engine isCellAtIndexPathSelectable:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.engine playerSelectedItemAtIndexPath:indexPath];
    [self.collectionView reloadData];
}

@end
