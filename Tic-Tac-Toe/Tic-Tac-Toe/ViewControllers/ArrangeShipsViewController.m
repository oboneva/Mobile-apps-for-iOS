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

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber *> *shipUnits;
@property (strong, nonatomic) NSArray<NSString *> *shipsNames;

@end

@implementation ArrangeShipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.defaultShips = [Utilities getDefaultShips].mutableCopy;
    [self countShipUnits];
    [self.doneButton setHidden:YES];
    
    self.board.delegate = self;
    self.board.dataSource = self;
    self.ships.delegate = self;
    self.ships.dataSource = self;

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanWithGestureRecognizer:)];
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationWithGestureRecognizer:)];
    
    panGestureRecognizer.delegate = self;
    rotationGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panGestureRecognizer];
    [self.view addGestureRecognizer:rotationGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)countShipUnits {
    NSNumber *value;
    self.shipUnits = [NSMutableDictionary new];
    for (ShipModel *ship in self.defaultShips) {
        value = self.shipUnits[ship.name];
        if (value) {
            self.shipUnits[ship.name] = [NSNumber numberWithInt:[value intValue] + 1];
        }
        else {
            self.shipUnits[ship.name] = @1;
        }
    }
    self.shipsNames = self.shipUnits.allKeys;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return gestureRecognizer.view == otherGestureRecognizer.view;
}

- (void)handlePanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint touchLocationShips = [panGestureRecognizer locationInView:self.ships];
    CGPoint touchLocationBoard = [panGestureRecognizer locationInView:self.board];
    
    NSIndexPath *touchedShipsCellIndex = [self.ships indexPathForItemAtPoint:touchLocationShips];
    NSIndexPath *touchedBoardCellIndex = [self.board indexPathForItemAtPoint:touchLocationBoard];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (touchedShipsCellIndex) {
            [self setDraggedShipCellAtIndexPath:touchedShipsCellIndex];
        }
        if (touchedBoardCellIndex) {
            [self setDraggedShipAtIndexPath:touchedBoardCellIndex];
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self draggedShipDroppedOnBoardAtIndexPath:touchedBoardCellIndex];
    }
    else if (self.draggedShip) {
        [self updateDraggedShipLocationWithPoint:touchLocationShips andIndexPath:touchedBoardCellIndex];
    }
}

- (void)updateDraggedShipLocationWithPoint:(CGPoint)point andIndexPath:(NSIndexPath *)indexPath {
    self.draggedShip.cell.image.center = CGPointMake(point.x - self.draggedShip.cell.frame.origin.x, point.y - self.draggedShip.cell.frame.origin.y);
    if (indexPath != self.draggedShip.previousHeadIndex) {
        [self cleanDraggedShipShadowOnBoard];
        [self setDraggedShipShadowOnBoardAtIndexPath:indexPath];
    }
}

- (void)setDraggedShipCellAtIndexPath:(NSIndexPath *)indexPath {
    ShipCell *draggedCell = (ShipCell *)[self.ships cellForItemAtIndexPath:indexPath];
    ShipModel *draggedShip = [self shipWithName:draggedCell.nameLabel.text];
    self.draggedShip = [DraggedShipModel newWithShip:draggedShip andCell:draggedCell];
}

- (void)setDraggedShipAtIndexPath:(NSIndexPath *)indexPath {
    ShipCell *draggedCell = (ShipCell *)nil;
    ShipModel *ship = [self.boardModel shipAtIndexPath:indexPath];
    if (ship) {
        [self.defaultShips addObject:ship];
        [self countShipUnits];
        self.draggedShip = [DraggedShipModel newWithShip:ship andCell:draggedCell];
        
        self.draggedShip.currentHeadIndex = ship.head;
        self.draggedShip.currentTailIndex = ship.tail;
        
        ship.head = nil;
        ship.tail = nil;
        
        
        if (self.draggedShip.currentHeadIndex.item == self.draggedShip.currentTailIndex.item) {
            self.draggedShip.orientation = EnumOrientationVertical;
        }
        else {
            self.draggedShip.orientation = EnumOrientationHorizontal;
        }
        
        [self reloadBoardCellsFromIndexPath:self.draggedShip.currentHeadIndex toIndexPath:self.draggedShip.currentTailIndex];
    }
}

- (BOOL)isDraggedShipLocationAvailable {
    if (!self.draggedShip.currentHeadIndex || !self.draggedShip.currentTailIndex) {
        return false;
    }
    return [self.boardModel couldArrangeShip:self.draggedShip.ship withHeadIndex:self.draggedShip.currentHeadIndex andTailIndex:self.draggedShip.currentTailIndex];
}

- (void)cleanDraggedShipShadowOnBoard {
    NSIndexPath *indexBegin = self.draggedShip.currentHeadIndex;
    NSIndexPath *indexEnd = self.draggedShip.currentTailIndex;
    self.draggedShip.previousHeadIndex = self.draggedShip.currentHeadIndex;
    [self.draggedShip resetOccupiedIndexes];
    [self reloadBoardValidCellsFromIndexPath:indexBegin toIndexPath:indexEnd];
}

- (NSIndexPath *)getIndexFromShipAfterIndex:(NSIndexPath *)indexPath {
    if (self.draggedShip.orientation == EnumOrientationHorizontal) {
        return [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
    }
    else {
        return [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section + 1];
    }
}

- (void)draggedShipDroppedOnBoardAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath && [self isDraggedShipLocationAvailable]) {
        [self setDroppedShipHeadAndTailAtIndexPath:indexPath];
        [self updateCollectionViewsAfterShipIsArranged];
    }
    else {
        [self cleanDraggedShipShadowOnBoard];
        [self returnCellToOriginalLocation];
    }
    [self draggedShipWasDropped];
}

- (void)draggedShipWasDropped {
    self.draggedShip = nil;
    if ([self areAllShipsArranged]) {
        [self.doneButton setHidden:NO];
    }
}

- (void)setShipCurrentHeadAndTailAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath) {
        self.draggedShip.currentHeadIndex = indexPath;
        self.draggedShip.currentTailIndex = [self tailIndexWithHeadIndex:indexPath];
    }
}

- (void)setDroppedShipHeadAndTailAtIndexPath:(NSIndexPath *)indexPath {
    self.draggedShip.ship.head = indexPath;
    self.draggedShip.ship.tail = [self tailIndexWithHeadIndex:indexPath];
}

- (NSIndexPath *)tailIndexWithHeadIndex:(NSIndexPath *)indexPath {
    if (self.draggedShip.orientation == EnumOrientationHorizontal) {
        return [NSIndexPath indexPathForItem:indexPath.item + self.draggedShip.ship.size - 1 inSection:indexPath.section];
    }
    else {
        return [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section + self.draggedShip.ship.size - 1];
    }
}

- (void)updateCollectionViewsAfterShipIsArranged {
    [self cleanDraggedShipShadowOnBoard];
    
    self.boardModel.ships = [self.boardModel.ships arrayByAddingObject:self.draggedShip.ship];
    [self reloadBoardCellsFromIndexPath:self.draggedShip.ship.head toIndexPath:self.draggedShip.ship.tail];
    
    [self.defaultShips removeObject:self.draggedShip.ship];
    [self countShipUnits];
    [self.ships reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (void)returnCellToOriginalLocation {
    [self.ships reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (void)setDraggedShipShadowOnBoardAtIndexPath:(NSIndexPath *)indexPath {
    [self setShipCurrentHeadAndTailAtIndexPath:indexPath];
    if ([self areCurrentHeadAndTailIndexesValid] && [self isDraggedShipLocationAvailable]) {
        self.draggedShip.currentIndexesAreValid = YES;
    }
    else {
        self.draggedShip.currentIndexesAreValid = NO;
    }
    [self reloadBoardValidCellsFromIndexPath:self.draggedShip.currentHeadIndex toIndexPath:self.draggedShip.currentTailIndex];
}

- (void)reloadBoardValidCellsFromIndexPath:(NSIndexPath *)indexBegin toIndexPath:(NSIndexPath *)indexEnd {
    if (![self isIndexValid:indexEnd]) {
        if (self.draggedShip.orientation == EnumOrientationHorizontal) {
            indexEnd = [NSIndexPath indexPathForItem:9 inSection:indexEnd.section];
        }
        else {
            indexEnd = [NSIndexPath indexPathForItem:indexEnd.item inSection:9];
        }
    }
    if (indexBegin) {
        [self reloadBoardCellsFromIndexPath:indexBegin toIndexPath:indexEnd];
    }
}

- (BOOL)areCurrentHeadAndTailIndexesValid {
    NSIndexPath *head = self.draggedShip.currentHeadIndex;
    NSIndexPath *tail = self.draggedShip.currentTailIndex;
    return (head && tail && head.item < [self.board numberOfItemsInSection:head.section] && head.section < [self.board numberOfSections] &&
            tail.section < [self.board numberOfSections] && tail.item < [self.board numberOfItemsInSection:tail.section]);
}

- (BOOL)isIndexValid:(NSIndexPath *)indexPath {
    return indexPath && indexPath.section < [self.board numberOfSections] && indexPath.item < [self.board numberOfItemsInSection:indexPath.section];
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

- (void)handleRotationWithGestureRecognizer:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    if (self.draggedShip.cell) {
        self.draggedShip.cell.image.transform = CGAffineTransformRotate(self.draggedShip.cell.image.transform, rotationGestureRecognizer.rotation);
        if (self.draggedShip.cell.image.frame.size.width < self.draggedShip.cell.image.frame.size.height) {
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
    return self.shipUnits.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    if (collectionView == self.board) {
        GameCell *gameCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_GAME_CELL forIndexPath:indexPath];
        gameCell.contentLabel.text = @"";
        [self setBackgroundColorToCell:gameCell atIndexPath:indexPath];
        cell = gameCell;
    }
    else {
        ShipCell *shipCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_SHIP_CELL forIndexPath:indexPath];
        ShipModel *ship = [self shipWithName:self.shipsNames[indexPath.item]];
        shipCell.nameLabel.text = ship.name;
        shipCell.sizeLabel.text = [NSString stringWithFormat:@"Size - %d", ship.size];
        shipCell.unitsLabel.text = [NSString stringWithFormat:@"x%@", self.shipUnits[ship.name]];
        shipCell.image.backgroundColor = [Utilities colorForShipWithName:ship.name];
        cell = shipCell;
    }
    
    cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0;
    return cell;
}

- (void)setBackgroundColorToCell:(GameCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if ([self isCellAtIndexPathOccupied:indexPath]) {
        if (self.draggedShip.currentIndexesAreValid) {
            cell.backgroundColor = [UIColor greenColor];
        }
        else {
            
            cell.backgroundColor = [UIColor redColor];
        }
    }
    else if ([self.boardModel shipAtIndexPath:indexPath]) {
        cell.backgroundColor = [Utilities colorForShipWithName:[self.boardModel shipAtIndexPath:indexPath].name];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (ShipModel *)shipWithName:(NSString *)name {
    for (ShipModel * ship in self.defaultShips) {
        if ([ship.name isEqualToString:name]) {
            return ship;
        }
    }
    return (ShipModel *)nil;
}

- (BOOL)isCellAtIndexPathOccupied:(NSIndexPath *)indexPath {
    return indexPath >= self.draggedShip.currentHeadIndex && indexPath <= self.draggedShip.currentTailIndex;
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
    self.shipUnits = @{}.mutableCopy;
    self.shipsNames = @[];
    [self.ships reloadData];
    [self.board reloadData];
    [self.doneButton setHidden:NO];
}

@end
