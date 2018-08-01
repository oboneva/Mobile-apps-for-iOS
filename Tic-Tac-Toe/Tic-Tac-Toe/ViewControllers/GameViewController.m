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

@interface GameViewController () <NotifyPlayerToPlayDelegate, EndGameDelegate, EngineDelegate>

@property (weak, nonatomic) IBOutlet UIView *matrixView;
@property (strong, nonatomic) MatrixCollectionViewController *matrixViewController; // to set data source and delegate

@property (weak, nonatomic) IBOutlet UILabel *player1InfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *player2InfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *endOfGameLabel;
@property (strong, nonatomic) UIColor *labelsColour;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;

@property (assign) BOOL isEngineSynchronized;
@property (strong, nonatomic) NSString *playerOnTurn;

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
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataWithNotification:) name:NOTIFICATION_RECEIVE_DATA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStateChange:) name:NOTIFICATION_CHANGED_STATE object:nil];
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.matrixViewController = (MatrixCollectionViewController *)[Utilities viewControllerWithClass:MatrixCollectionViewController.class];
    self.matrixViewController = segue.destinationViewController;
    
    /*
    self.matrixViewController.peer = self.peer;
    self.matrixViewController.engine = self.engine;
    self.matrixViewController.notifyPlayerToPlayDelegate = self;
    self.matrixViewController.endGameDelegate = self;
    */
    
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

/*
- (void)didStateChange:(NSNotification *)notif {
    NSNumber *stateWrapper = (NSNumber *)notif.userInfo[@"state"];
    MCSessionState state = (MCSessionState)stateWrapper.intValue;
    
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

- (void)sendTheFirstPlayerOnTurn:(NSString *)playerName {
    NSString *string = [[NSString alloc] initWithFormat:@"%ld - %@", EnumSendDataTurn, playerName];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *peers = @[self.peer];
    NSError *error;
    
    [MultipeerConectivityManager.sharedInstance.session sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:&error];
}
*/

- (IBAction)onNewGameTap:(id)sender {
    [self.startNewGameButton setHidden:YES];
    self.endOfGameLabel.text = @"";
    if (self.gameMode == EnumGameModeOneDevice) {
        [self.engine newGame];
    }
    else {/*
        if (!self.isEngineSynchronized) {
            [self.engine setUpPlayers];
            [self sendTheFirstPlayerOnTurn:self.engine.currentPlayer.name];
            self.isEngineSynchronized = true;
        }
        else if ([self.playerOnTurn isEqualToString:self.engine.player1.name]) {
            [self.engine customSetUpPlayersWithFirstPlayerOnTurn:self.engine.player1];
        }
        else {
            [self.engine customSetUpPlayersWithFirstPlayerOnTurn:self.engine.player2];
        }
        [self.engine newMultipeerGame];*/
    }
    
    self.matrixView.userInteractionEnabled = YES;
}
/*
- (void)sendCellMarkedAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringData = [NSString stringWithFormat:@"%ld - %d,%d", EnumSendDataCoordinates, (int)indexPath.section, (int)indexPath.row];
    NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *peers = @[self.peer];
    NSError *error;
    
    [MultipeerConectivityManager.sharedInstance.session sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:&
     error];
}

- (void)didReceiveDataWithNotification:(NSNotification *)notification {
    NSData *data = [[notification userInfo] objectForKey:@"data"];
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *stringComponents = [dataString componentsSeparatedByString:DATA_SEPARATOR];
    if ([stringComponents.firstObject intValue] == EnumSendDataCoordinates ) {
        [self didReceiveCoordinatesWithString:stringComponents.lastObject];
    }
    else if ([stringComponents.firstObject intValue] == EnumSendDataTurn) {
        [self didReceivePlayerOnTurnWithString:stringComponents.lastObject];
    }
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
    self.playerOnTurn = string;
}
*/

// EngineDelegate methods

- (EnumGame)getGameType {
    return self.gameType;
}

- (EnumGameMode)getGameMode {
    return self.gameMode;
}

- (PlayerModel *)currentPlayer {
    return self.currentPlayer;
}

- (PlayerModel *)player1 {
    return self.player1;
}

- (PlayerModel *)player2 {
    return self.player2;
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

- (void)startGame {
    [self.engine startGame];
}

- (void)newGame {
    [self.engine newGame];
}
@end
