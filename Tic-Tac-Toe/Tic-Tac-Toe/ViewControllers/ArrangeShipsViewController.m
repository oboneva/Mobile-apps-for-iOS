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

#import "ShipCell.h"

#import "Utilities.h"
#import "Constants.h"

#import "ShipsCollectionViewDataSourceDelegate.h"
#import "BoardCollectionViewDataSourceDelegate.h"

@interface ArrangeShipsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *boardCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *shipsCollectionView;

@property (strong, nonatomic) DraggedShipModel *draggedShip;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) ShipsCollectionViewDataSourceDelegate *shipsDataSource;
@property (strong, nonatomic) BoardCollectionViewDataSourceDelegate *boardDataSource;

@end

@implementation ArrangeShipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.doneButton setHidden:YES];
    [self setUpGestureRecognizers];
    
    self.boardDataSource = [BoardCollectionViewDataSourceDelegate dataSource];
    self.boardDataSource.board = self.boardModel;
    self.boardCollectionView.dataSource = self.boardDataSource;
    
    self.shipsDataSource = [ShipsCollectionViewDataSourceDelegate dataSource];
    self.shipsDataSource.boardCellSize = [self.boardCollectionView contentSize].width * 0.1;
    self.shipsCollectionView.dataSource = self.shipsDataSource;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpGestureRecognizers {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanWithGestureRecognizer:)];
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationWithGestureRecognizer:)];
    
    panGestureRecognizer.delegate = self;
    rotationGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panGestureRecognizer];
    [self.view addGestureRecognizer:rotationGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return gestureRecognizer.view == otherGestureRecognizer.view;
}

- (void)handlePanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint touchLocationWindow = [panGestureRecognizer locationInView:self.view];
    CGPoint touchLocationShips = [panGestureRecognizer locationInView:self.shipsCollectionView];
    CGPoint touchLocationBoard = [panGestureRecognizer locationInView:self.boardCollectionView];
    
    NSIndexPath *touchedShipsCellIndex = [self.shipsCollectionView indexPathForItemAtPoint:touchLocationShips];
    NSIndexPath *touchedBoardCellIndex = [self.boardCollectionView indexPathForItemAtPoint:touchLocationBoard];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (touchedShipsCellIndex) {
            [self setDraggedShipCellAtIndexPath:touchedShipsCellIndex withPoint:touchLocationWindow];
        }
        else if (touchedBoardCellIndex) {
            [self setDraggedShipFromBoardAtIndexPath:touchedBoardCellIndex withPoint:touchLocationWindow];
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self draggedShipDroppedOnBoardAtIndexPath:touchedBoardCellIndex];
    }
    else if (self.draggedShip) {
        [self updateDraggedShipLocationWithPoint:touchLocationWindow andIndexPath:touchedBoardCellIndex];
    }
}

- (void)updateDraggedShipLocationWithPoint:(CGPoint)point andIndexPath:(NSIndexPath *)indexPath {
    self.draggedShip.imageView.center = point;
    
    if (indexPath != self.draggedShip.previousHeadIndex) {
        [self cleanDraggedShipShadowOnBoard];
        [self setDraggedShipShadowOnBoardAtIndexPath:indexPath];
    }
}

- (void)setDraggedShipCellAtIndexPath:(NSIndexPath *)indexPath withPoint:(CGPoint)point {
    ShipCell *draggedShipCell = (ShipCell *)[self.shipsCollectionView cellForItemAtIndexPath:indexPath];
    [draggedShipCell.imageView setHidden:YES];
    
    ShipModel *ship = [self.shipsDataSource shipWithName:draggedShipCell.nameLabel.text];
    self.draggedShip = [DraggedShipModel newWithShip:ship andImageView:draggedShipCell.imageView];
    self.boardDataSource.draggedShip = self.draggedShip;

    [self setDraggedShipImageVisibleEverywhere:YES];
}

- (void)setDraggedShipImageVisibleEverywhere:(BOOL)isVisible {
    if (isVisible) {
        [self.view.superview addSubview:self.draggedShip.imageView];
    }
    else {
        [self.draggedShip.imageView removeFromSuperview];
    }
}

- (void)setDraggedShipFromBoardAtIndexPath:(NSIndexPath *)indexPath withPoint:(CGPoint)point{
    ShipModel *ship = [self.boardModel shipAtIndexPath:indexPath];
    if (ship) {
        [self removeShipFromArranged:ship];
        
        [self.shipsCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        ShipCell *draggedCell = [self shipCellForShipWithName:ship.name];
        self.draggedShip = [DraggedShipModel newWithShip:ship andImageView:draggedCell.imageView];
        self.boardDataSource.draggedShip = self.draggedShip;
        self.draggedShip.imageView.center = point;
        
        self.draggedShip.currentHeadIndex = ship.head;
        self.draggedShip.currentTailIndex = ship.tail;
        
        [self setAppropriateOrientationToDraggedShip];
        [self setDraggedShipImageVisibleEverywhere:YES];
        
        ship.head = nil;
        ship.tail = nil;
        
        [self reloadBoardCellsFromIndexPath:self.draggedShip.currentHeadIndex toIndexPath:self.draggedShip.currentTailIndex];
    }
}

- (void)removeShipFromArranged:(ShipModel *)ship {
    [self.shipsDataSource.defaultShips addObject:ship];
    [self.shipsDataSource countShipUnits];
    [self.boardModel.ships removeObject:ship];
}

- (void)setAppropriateOrientationToDraggedShip {
    if (self.draggedShip.currentHeadIndex.section == self.draggedShip.currentTailIndex.section) {
        self.draggedShip.orientation = EnumOrientationHorizontal;
        self.draggedShip.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    else {
        self.draggedShip.orientation = EnumOrientationVertical;
        self.draggedShip.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
}

- (void)draggedShipDroppedOnBoardAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath && [self isDraggedShipLocationAvailable]) {
        [self setDroppedShipHeadAndTailAtIndexPath:indexPath];
        [self updateCollectionViewsAfterShipIsArranged];
    }
    else if (self.draggedShip){
        [self cleanDraggedShipShadowOnBoard];
        [self returnCellToOriginalLocation];
    }
    
    [self setDraggedShipImageVisibleEverywhere:NO];
    [self draggedShipWasDropped];
}

- (void)setDraggedShipShadowOnBoardAtIndexPath:(NSIndexPath *)indexPath {
    [self setShipCurrentHeadAndTailAtIndexPath:indexPath];
    
    self.draggedShip.currentIndexesAreValid = ([self areCurrentHead:self.draggedShip.currentHeadIndex andTailIndexesValid:self.draggedShip.currentTailIndex] && [self isDraggedShipLocationAvailable]);

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
    if (indexEnd) {
        [cellsToBeReloaded addObject:indexEnd];
    }
    
    [self.boardCollectionView reloadItemsAtIndexPaths:cellsToBeReloaded];
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

- (void)draggedShipWasDropped {
    self.draggedShip = nil;
    if ([self areAllShipsArranged]) {
        [self.doneButton setHidden:NO];
    }
    else {
        [self.doneButton setHidden:YES];
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
    
    [self.boardModel.ships addObject:self.draggedShip.ship];
    [self reloadBoardCellsFromIndexPath:self.draggedShip.ship.head toIndexPath:self.draggedShip.ship.tail];
    
    [self.shipsDataSource.defaultShips removeObject:self.draggedShip.ship];
    [self.shipsDataSource countShipUnits];
    [self.shipsCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    [self setAllShipsImagesVisible];
}

- (void)returnCellToOriginalLocation {
    [self.shipsCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    [self setAllShipsImagesVisible];
}

- (void)handleRotationWithGestureRecognizer:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    if (self.draggedShip.imageView) {
        self.draggedShip.imageView.transform = CGAffineTransformRotate(self.draggedShip.imageView.transform, rotationGestureRecognizer.rotation);
        rotationGestureRecognizer.rotation = 0.0;
        [self updateOrientation];
    }
}

- (void)updateOrientation {
    if (self.draggedShip.imageView.frame.size.width < self.draggedShip.imageView.frame.size.height) {
        self.draggedShip.orientation = EnumOrientationVertical;
    }
    else {
        self.draggedShip.orientation = EnumOrientationHorizontal;
    }
}

- (IBAction)onDoneTap:(id)sender {
    [self.gameViewDelegate shipsAreArranged];
}     

- (IBAction)onRandomArrangeTap:(id)sender {
    self.boardModel.ships = [Utilities getDefaultShips].mutableCopy;
    [self.boardModel randomArrangeShips];
    self.shipsDataSource.defaultShips = @[].mutableCopy;
    self.shipsDataSource.shipUnits = @{}.mutableCopy;
    [self.shipsCollectionView reloadData];
    [self.boardCollectionView reloadData];
    [self.doneButton setHidden:NO];
}

- (void)setAllShipsImagesVisible {
    ShipCell * cell;
    for (NSInteger i = 0 ; i <[self.shipsCollectionView numberOfItemsInSection:0]; i++) {
        cell = (ShipCell *)[self.shipsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if ([cell.imageView isHidden])
        {
            [cell.imageView setHidden:NO];
        }
    }
}

- (ShipCell *)shipCellForShipWithName:(NSString *)shipName {
    ShipCell *shipCell;
    for (NSInteger i = 0; i < [self.shipsCollectionView numberOfItemsInSection:0]; i++) {
        shipCell = (ShipCell *)[self.shipsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if (shipCell.nameLabel.text == shipName) {
            return shipCell;
        }
    }
    return (ShipCell *)nil;
}

- (BOOL)areAllShipsArranged {
    return self.shipsDataSource.defaultShips.count == 0;
}

- (BOOL)areCurrentHead:(NSIndexPath *)head andTailIndexesValid:(NSIndexPath *)tail {
    return (head && tail && head.item < [self.boardCollectionView numberOfItemsInSection:head.section] && head.section < [self.boardCollectionView numberOfSections] &&
            tail.section < [self.boardCollectionView numberOfSections] && tail.item < [self.boardCollectionView numberOfItemsInSection:tail.section]);
}

- (BOOL)isIndexValid:(NSIndexPath *)indexPath {
    return indexPath && indexPath.section < [self.boardCollectionView numberOfSections] && indexPath.item < [self.boardCollectionView numberOfItemsInSection:indexPath.section];
}

@end
