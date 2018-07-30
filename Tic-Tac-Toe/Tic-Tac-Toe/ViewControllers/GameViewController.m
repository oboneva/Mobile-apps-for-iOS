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

#import "Utilities.h"
#import "MultipeerConectivityManager.h"
#import "Protocols.h"

@interface GameViewController () <NotifyPlayerToPlayDelegate, EndGameDelegate>

@property (weak, nonatomic) IBOutlet UIView *matrixView;
@property (strong, nonatomic) MatrixCollectionViewController *matrixViewController;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataWithNotification:) name:NOTIFICATION_RECEIVE_DATA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStateChange:) name:NOTIFICATION_CHANGED_STATE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.matrixViewController = (MatrixCollectionViewController *)[Utilities viewControllerWithClass:MatrixCollectionViewController.class];
    self.matrixViewController = segue.destinationViewController;
    self.matrixViewController.peer = self.peer;
    self.matrixViewController.engine = self.engine;
    self.matrixViewController.notifyPlayerToPlayDelegate = self;
    self.matrixViewController.endGameDelegate = self;
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

- (void)didStateChange:(NSNotification *)notif {
    
    NSNumber *stateWrapper = (NSNumber *)notif.userInfo[@"state"];
    MCSessionState state = (MCSessionState)stateWrapper.intValue;
    
    if (state == MCSessionStateNotConnected) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"The other player quit the game." message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* quit = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:quit];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveDataWithNotification:(NSNotification *)notification {
    NSData *data = [[notification userInfo] objectForKey:@"data"];
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.playerOnTurn = stringData;
}

- (void)sendTheFirstPlayerOnTurn:(NSString *)playerName {
    NSData *data = [playerName dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *peers = @[self.peer];
    NSError *error;
    [MultipeerConectivityManager.sharedInstance.session sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:&error];
}

- (IBAction)onNewGameTap:(id)sender {
    [self.startNewGameButton setHidden:YES];
    self.endOfGameLabel.text = @"";
    if (self.gameMode == EnumGameModeOneDevice) {
        [self.engine newGame];
    }
    else {
        //
        
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
        
        //
        [self.engine newMultipeerGame];
    }
    
    self.matrixView.userInteractionEnabled = YES;
}

@end
