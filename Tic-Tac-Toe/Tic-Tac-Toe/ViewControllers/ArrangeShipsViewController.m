//
//  ArrangeShipsViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 21.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ArrangeShipsViewController.h"
#import "GameViewController.h"

#import "ShipModel.h"
#import "BoardModel.h"
#import "HumanModel.h"
#import "BotModel.h"

#import "GameCell.h"
#import "ShipCell.h"

#import "Utilities.h"
#import "Constants.h"

#define BOARD_SECTION_COUNT 10
#define SHIPS_SECTION_COUNT 1

@interface ArrangeShipsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *board;
@property (weak, nonatomic) IBOutlet UICollectionView *ships;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) NSMutableArray<ShipModel *> *defaultShips;

@end

@implementation ArrangeShipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.defaultShips = [Utilities getDefaultShips].mutableCopy;
    [self.doneButton setHidden:YES];
    
    self.board.delegate = self;
    self.board.dataSource = self;
    self.ships.delegate = self;
    self.ships.dataSource = self;
    /*
    if (@available(iOS 11.0, *)) {
        self.ships.dragDelegate = self;
        [self.ships dragInteractionEnabled];
    } else {
        // Fallback on earlier versions
        NSLog(@"asdfsdfdfgdf");
    }
     */
    
    //[self.ships allowsSelection];
    [self arrangeUserShipsTemp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.board) {
        return BOARD_SECTION_COUNT;
    }
    return SHIPS_SECTION_COUNT;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.board) {
        return BOARD_SECTION_COUNT;
    }
    return self.defaultShips.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    if (collectionView == self.board) {
        GameCell *gameCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_GAME_CELL forIndexPath:indexPath];
        gameCell.contentLabel.text = @"";
        cell = gameCell;
    }
    else {
        ShipCell *shipCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_SHIP_CELL forIndexPath:indexPath];
        shipCell.nameLabel.text = self.defaultShips[indexPath.item].name;
        //shipCell.sizeLabel.text = [self.defaultShips[indexPath.item].size stringValue];
        cell = shipCell;
    }
    
    cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0;
    return cell;
}

- (BOOL)areAllShipsArranged {
    return self.defaultShips.count == 0;
}

/*
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    NSItemProvider *item = [[NSItemProvider alloc] initWithObject:[self.defaultShipSize[self.defaultShipsNames[indexPath.item]] stringValue]];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:item];
    return @[dragItem];
}
*/

- (void)arrangeUserShipsTemp {
    self.boardModel.ships = [Utilities getDefaultShips];
    int i = 0;
    for (ShipModel *ship in self.boardModel.ships) {
        ship.head = [NSIndexPath indexPathForItem:0 inSection:i];
        ship.tail = [NSIndexPath indexPathForItem:ship.size - 1 inSection:i];
        i++;
    }
    [self.doneButton setHidden:NO];
}

- (IBAction)onDoneTap:(id)sender {
    [self.arrangeShipsDelegate shipsAreArranged];
}


@end
