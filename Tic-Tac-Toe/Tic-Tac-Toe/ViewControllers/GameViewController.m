//
//  GameViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "GameEngine.h"

#import "GameViewController.h"
#import "MatrixCollectionViewController.h"

#import "PlayerModel.h"
#import "GameCellModel.h"
#import "TunakTunakTunCellModel.h"
#import "TicTacToeCellModel.h"

#import "GameCell.h"

#import "Utilities.h"
#import "MultipeerConectivityManager.h"
#import "Protocols.h"

@interface GameViewController () <NotifyPlayerToPlayDelegate, EndGameDelegate, EngineDelegate, PeerSessionDelegate>

@property (weak, nonatomic) IBOutlet UIView *matrixView;
@property (strong, nonatomic) MatrixCollectionViewController *matrixViewController;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *player1InfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *player2InfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *endOfGameLabel;
@property (strong, nonatomic) UIColor *labelsColour;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;

@property (assign) BOOL otherPlayerTappedNewGame;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.player1InfoLabel.text = self.engine.player1.name;
    [self.player1InfoLabel sizeToFit];
    self.player2InfoLabel.text = self.engine.player2.name;
    [self.player2InfoLabel sizeToFit];
    self.endOfGameLabel.text = @"";
    
    self.labelsColour = [[UIColor alloc] initWithRed:255/255 green:102/255 blue:102/255 alpha:1.0];
    [self.startNewGameButton setHidden:YES];
    MultipeerConectivityManager.sharedInstance.peerSessionDelegate = self;

    [self.activityIndicator setHidesWhenStopped:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.matrixViewController = (MatrixCollectionViewController *)[Utilities viewControllerWithClass:MatrixCollectionViewController.class];
    self.matrixViewController = segue.destinationViewController;
    self.matrixViewController.engineDelegate = self;
    self.engine.notifyPlayerToPlayDelegate = self;
    self.engine.endGameDelegate = self;
}

-(void)didChangePlayerToPlayWithName:(NSString *)playerName {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([playerName isEqualToString:self.engine.player1.name]) {
            self.player1InfoLabel.textColor = self.labelsColour;
            self.player2InfoLabel.textColor = [UIColor grayColor];
        }
        else {
            self.player1InfoLabel.textColor = [UIColor grayColor];
            self.player2InfoLabel.textColor = self.labelsColour;
        }
    });
}

- (void)didEndGameWithNoWinner {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.endOfGameLabel.text = @"No winner";
        self.endOfGameLabel.textColor = self.labelsColour;
        self.matrixView.userInteractionEnabled = NO;
        [self.startNewGameButton setHidden:NO];
    });
}

- (void)didEndGameWithWinner:(PlayerModel *)winner {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.endOfGameLabel.text = [[NSString alloc] initWithFormat:@"%@ won", winner.name];
        self.endOfGameLabel.textColor = self.labelsColour;
        [self.endOfGameLabel sizeToFit];
        self.matrixView.userInteractionEnabled = NO;
        [self.startNewGameButton setHidden:NO];
    });
}

-(void)forceRefresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.matrixViewController.collectionView reloadData];
    });
}

- (IBAction)onNewGameTap:(id)sender {
    [self.startNewGameButton setHidden:YES];
    self.endOfGameLabel.text = @"";
    if (self.gameMode == EnumGameModeOneDevice) {
        [self.engine newGame];
    }
    
    if (self.roomBelongsToMe) {
        [self.engine setUpPlayers];
        [self sendTheFirstPlayerOnTurn:self.engine.currentPlayer.name];
        if (self.otherPlayerTappedNewGame) {
            self.otherPlayerTappedNewGame = false;
            [self.engine newMultipeerGame];
        }
        else {
            [self.activityIndicator startAnimating];
        }
    }
    else {
        [self sendTappedNewGame];
        if(self.otherPlayerTappedNewGame) {
            self.otherPlayerTappedNewGame = false;
            [self.engine newMultipeerGame];
        }
        else {
            [self.activityIndicator startAnimating];
        }
    }
    
    self.matrixView.userInteractionEnabled = YES;
}

//two devices
- (void)sendCellMarkedAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringData = [NSString stringWithFormat:@"%ld - %d,%d", EnumSendDataCoordinates, (int)indexPath.section, (int)indexPath.row];
    NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    [MultipeerConectivityManager.sharedInstance sendData:data toPeer:self.peer];
}

- (void)sendTheFirstPlayerOnTurn:(NSString *)name {
    NSString *turn = [[NSString alloc] initWithFormat:@"%ld - %@", EnumSendDataTurn, name];
    NSData *data = [turn dataUsingEncoding:NSUTF8StringEncoding];
    [MultipeerConectivityManager.sharedInstance sendData:data toPeer:self.peer];
}

- (void)sendTappedNewGame {
    NSString *turn = [[NSString alloc] initWithFormat:@"%ld - %@", EnumSendDataReadyToPlay, self.engine.player1.name];
    NSData *data = [turn dataUsingEncoding:NSUTF8StringEncoding];
    [MultipeerConectivityManager.sharedInstance sendData:data toPeer:self.peer];
}

- (void)didReceiveCoordinatesWithString:(NSString *)string {
    NSInteger section = [[string substringFromIndex:0] intValue];
    NSInteger row = [[string substringFromIndex:2] intValue];
    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self.engine playerSelectedItemAtIndexPath:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.matrixViewController.collectionView reloadData];
    });
}

- (void)didReceivePlayerOnTurnWithString:(NSString *)string {
    if (!self.roomBelongsToMe && [string isEqualToString:self.engine.player1.name]) {
        self.engine.currentPlayer = self.engine.player1;
    }
    else if (!self.roomBelongsToMe) {
        self.engine.currentPlayer = self.engine.player2;
    }
    self.otherPlayerTappedNewGame = true;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.activityIndicator isAnimating]) {
            [self.activityIndicator stopAnimating];
            self.otherPlayerTappedNewGame = false;
            [self.engine newMultipeerGame];
        }
    });
    
}

- (void)didReceiveJoinedPlayerStartedNewGame {
    self.otherPlayerTappedNewGame = true;
    __block BOOL isActivityIndicatorAnimating;
    dispatch_async(dispatch_get_main_queue(), ^{
        isActivityIndicatorAnimating = [self.activityIndicator isAnimating];
    });
    if (isActivityIndicatorAnimating) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.otherPlayerTappedNewGame = false;
            [self.engine newMultipeerGame];
        });
    }
}

// EngineDelegate methods

- (EnumGame)getGameType {
    return self.gameType;
}

- (EnumGameMode)getGameMode {
    return self.gameMode;
}

- (PlayerModel *)getCurrentPlayer {
    return self.engine.currentPlayer;
}

- (PlayerModel *)getPlayer1 {
    return self.engine.player1;
}

- (int)rowsCount {
    return self.engine.rowsCount;
}

- (int)itemsCount {
    return self.engine.itemsCount;
}

- (GameCellModel *)getCellAtIndex:(NSIndexPath *)indexPath {
    return [self.engine getCellAtIndex:indexPath];
}

- (BOOL)isCellAtIndexPathSelectable:(NSIndexPath *)indexPath {
    return [self.engine isCellAtIndexPathSelectable:indexPath];
}

- (void)playerSelectedItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.engine playerSelectedItemAtIndexPath:indexPath];
}

- (void)cellMarkedAtIndexPath:(NSIndexPath *)indexPath {
    [self sendCellMarkedAtIndexPath:indexPath];
}

- (void)startGame {
    if (self.gameMode == EnumGameModeOneDevice) {
        [self.engine startGame];
    }
    else {
        [self.engine startMultipeerGame];
    }
}

- (void)peer:(MCPeerID *)peerID changedState:(MCSessionState)state {
    if (state == MCSessionStateNotConnected) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"The other player quit the game." message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* quit = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
            });
        }];
        
        [alert addAction:quit];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *stringComponents = [dataString componentsSeparatedByString:DATA_SEPARATOR];
    if ([stringComponents.firstObject intValue] == EnumSendDataCoordinates ) {
        [self didReceiveCoordinatesWithString:stringComponents.lastObject];
    }
    else if ([stringComponents.firstObject intValue] == EnumSendDataTurn) {
        [self didReceivePlayerOnTurnWithString:stringComponents.lastObject];
    }
    else if([stringComponents.firstObject intValue] == EnumSendDataReadyToPlay) {
        [self didReceiveJoinedPlayerStartedNewGame];
    }
}

@end
