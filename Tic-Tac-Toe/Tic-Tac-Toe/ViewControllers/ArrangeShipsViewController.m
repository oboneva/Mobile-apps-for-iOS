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
#import "DraggedShipModel.h"

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
@property (strong, nonatomic) DraggedShipModel *draggedShip;

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

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanWithGestureRecognizer:)];
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationWithGestureReconzier:)];
    
    panGestureRecognizer.delegate = self;
    rotationGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panGestureRecognizer];
    [self.view addGestureRecognizer:rotationGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return gestureRecognizer.view == otherGestureRecognizer.view;
}

- (void)handlePanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    [self cleanDraggedShipShadowOnBoard];
    
    CGPoint touchLocationShips = [panGestureRecognizer locationInView:self.ships];
    CGPoint touchLocationBoard = [panGestureRecognizer locationInView:self.board];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *touchedShipsCellIndex = [self.ships indexPathForItemAtPoint:touchLocationShips];
        [self setDraggedShipCellAtIndexPath:touchedShipsCellIndex];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath *touchedBoardCellIndex = [self.board indexPathForItemAtPoint:touchLocationBoard]; //empty array
        [self draggedShipDroppedOnBoardAtIndexPath:touchedBoardCellIndex];
    }
    else if (self.draggedShip) {
        self.draggedShip.cell.center = touchLocationShips;
        NSIndexPath *touchedBoardCellIndex = [self.board indexPathForItemAtPoint:touchLocationBoard];
        [self setDraggedShipShadowOnBoardAtIndexPath:touchedBoardCellIndex];
    }
}

- (void)setDraggedShipCellAtIndexPath:(NSIndexPath *)indexPath {
    ShipModel *draggedShip = self.defaultShips[indexPath.item];
    ShipCell *draggedCell = (ShipCell *)[self.ships cellForItemAtIndexPath:indexPath];
    self.draggedShip = [DraggedShipModel newWithShip:draggedShip andCell:draggedCell];
}

- (void)cleanDraggedShipShadowOnBoard {
    if (self.draggedShip.currentHeadIndex && self.draggedShip.currentTailIndex) {
        NSArray *cellsWithShadow = @[self.draggedShip.currentHeadIndex, self.draggedShip.currentTailIndex];
        self.draggedShip.currentHeadIndex = nil;
        self.draggedShip.currentTailIndex = nil;
        [self.board reloadItemsAtIndexPaths:cellsWithShadow];
    }
}

- (void)draggedShipDroppedOnBoardAtIndexPath:(NSIndexPath *)indexPath {
    self.draggedShip.ship.head = indexPath;
    if (self.draggedShip.orientation == EnumOrientationHorizontal) {
        self.draggedShip.ship.tail = [NSIndexPath indexPathForItem:indexPath.item + self.draggedShip.ship.size - 1 inSection:indexPath.section];
    }
    else {
        self.draggedShip.ship.tail = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section + self.draggedShip.ship.size - 1];
    }
    
    self.boardModel.ships = [self.boardModel.ships arrayByAddingObject:self.draggedShip.ship];
    [self reloadBoardCellsFromIndexPath:self.draggedShip.ship.head toIndexPath:self.draggedShip.ship.tail];
    [self.defaultShips removeObject:self.draggedShip.ship];
    self.draggedShip.ship = nil;
    self.draggedShip.orientation = EnumOrientationHorizontal;
    [self.ships reloadData];
    if ([self areAllShipsArranged]) {
        [self.doneButton setHidden:NO];
    }
}

- (void)setDraggedShipShadowOnBoardAtIndexPath:(NSIndexPath *)indexPath {
    self.draggedShip.currentHeadIndex = indexPath;
    if (self.draggedShip.orientation == EnumOrientationHorizontal) {
        self.draggedShip.currentTailIndex = [NSIndexPath indexPathForItem:self.draggedShip.currentHeadIndex.item + self.draggedShip.ship.size - 1 inSection:self.draggedShip.currentHeadIndex.section];
    }
    else {
        self.draggedShip.currentTailIndex = [NSIndexPath indexPathForItem:self.draggedShip.currentHeadIndex.item inSection:self.draggedShip.currentHeadIndex.section + self.draggedShip.ship.size - 1];
    }
    
    if (self.draggedShip.currentTailIndex && self.draggedShip.currentHeadIndex) {
        [self.board reloadItemsAtIndexPaths:@[self.draggedShip.currentHeadIndex, self.draggedShip.currentTailIndex]];
    }
}

- (void)reloadBoardCellsFromIndexPath:(NSIndexPath *)indexBegin toIndexPath:(NSIndexPath *)indexEnd {
    NSMutableArray<NSIndexPath *> *cellsToBeReloaded = [[NSMutableArray alloc] init];
    while(indexBegin != indexEnd) {
        [cellsToBeReloaded addObject:indexBegin];
        if (indexBegin.item == indexEnd.item) {
            indexBegin = [NSIndexPath indexPathForItem:indexBegin.item inSection:indexBegin.section + 1];
        }
        else {
            indexBegin = [NSIndexPath indexPathForItem:indexBegin.item + 1 inSection:indexBegin.section];
        }
    }
    [cellsToBeReloaded addObject:indexEnd];
    [self.board reloadItemsAtIndexPaths:cellsToBeReloaded];
}

- (void)handleRotationWithGestureReconzier:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    if (self.draggedShip.cell) {
        self.draggedShip.cell.transform = CGAffineTransformRotate(self.draggedShip.cell.transform, rotationGestureRecognizer.rotation);
        if (self.draggedShip.cell.frame.size.width < self.draggedShip.cell.frame.size.height) {
            self.draggedShip.orientation = EnumOrientationVertical;
        }
        else {
            self.draggedShip.orientation = EnumOrientationHorizontal;
        }
        rotationGestureRecognizer.rotation = 0.0;
    }
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
        if (indexPath == self.draggedShip.currentHeadIndex || indexPath == self.draggedShip.currentTailIndex) {
            cell.backgroundColor = [UIColor greenColor];
        }
        else if ([self.boardModel isCellAtIndexPathPartOfShip:indexPath]) {
            cell.backgroundColor = [UIColor colorWithRed:0/255 green:128/255 blue:255/255 alpha:1.0];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    else {
        ShipCell *shipCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_SHIP_CELL forIndexPath:indexPath];
        shipCell.nameLabel.text = self.defaultShips[indexPath.item].name;
        cell = shipCell;
    }
    
    cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0;
    return cell;
}

- (BOOL)areAllShipsArranged {
    return self.defaultShips.count == 0;
}

- (IBAction)onDoneTap:(id)sender {
    [self.arrangeShipsDelegate shipsAreArranged];
}

- (IBAction)onRandomArrangeTap:(id)sender {
    self.boardModel.ships = [Utilities getDefaultShips];
    [self.boardModel randomArrangeShips];
    self.defaultShips = @[].mutableCopy;
    [self.ships reloadData];
    [self.board reloadData];
    [self.doneButton setHidden:NO];
}

@end
