//
//  MultiplePlayersViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "MultiplePlayersViewController.h"
#import "GameViewController.h"

#import "PlayerModel.h"
#import "HumanModel.h"

#import "GameEngine.h"

#import "Utilities.h"
#import "MultipeerConectivityManager.h"

#define TunakTunakTun   @"TunakTunak"
#define TicTacToe       @"TicTac"

@interface MultiplePlayersViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstPlayerName;
@property (weak, nonatomic) IBOutlet UITextField *secondPlayerName;
@property (assign) EnumGame gameType;
@property (assign) BOOL isEngineSynchronized;
@property (strong, nonatomic) NSString *playerOnTurn;
@end

@implementation MultiplePlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.gameType = EnumGameTicTacToe;
    self.playerOnTurn = @"";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.firstPlayerName.delegate = self;
    self.secondPlayerName.delegate = self;
    
    self.isEngineSynchronized = false;
    if (self.gameMode == EnumGameModeTwoDevices) {
        [self.secondPlayerName setHidden:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataWithNotification:) name:NOTIFICATION_RECEIVE_DATA object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    if (self.gameMode == EnumGameModeTwoDevices) {
        [self sendMyNameToTheOtherPlayer];
    }
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.gameMode == EnumGameModeTwoDevices) {
        [self sendMyNameToTheOtherPlayer];
    }
    return YES;
}

- (void)sendMyNameToTheOtherPlayer {
    NSData *data = [self.firstPlayerName.text dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}

- (void)sendTheGameType:(NSString *)gameType {
    NSData *data = [gameType dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}

- (void)sendTheFirstPlayerOnTurn:(NSString *)playerName {
    NSData *data = [playerName dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}

- (void)sendData:(NSData *)data {
    NSArray *peers = @[self.peer];
    NSError *error;
    [MultipeerConectivityManager.sharedInstance.session sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:&
     error];
}

- (IBAction)onPlayTap:(id)sender {
    GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];
    HumanModel *player1 = [[HumanModel alloc] initWithName:self.firstPlayerName.text];
    HumanModel *player2 = [[HumanModel alloc] initWithName:self.secondPlayerName.text];
    
    GameEngine *engine = [Utilities gameEngineFromType:self.gameType];
    engine.player1 = player1;
    engine.player2 = player2;
    gameController.peer = self.peer;
    gameController.gameMode = self.gameMode;
    
    if (self.gameMode == EnumGameModeTwoDevices && !self.isEngineSynchronized) { // first
        [engine setUpPlayers];
        [self sendTheFirstPlayerOnTurn:engine.currentPlayer.name];
        self.isEngineSynchronized = true;
    }
    else if (self.gameMode == EnumGameModeTwoDevices) { // in the other device, we set up the current player, based on the received info
        if ([self.playerOnTurn isEqualToString:player1.name]) {
            [engine customSetUpPlayersWithFirstPlayerOnTurn:player1];
        }
        else {
            [engine customSetUpPlayersWithFirstPlayerOnTurn:player2];
        }
    }

    [gameController setEngine:engine];
    //remove observer??
    [self.navigationController pushViewController:gameController animated:YES];
}

- (IBAction)onGameSwitchTap:(id)sender {
    if (self.gameType == EnumGameTicTacToe) {
        self.gameType = EnumGameTunakTunakTun;
        [self sendTheGameType:TunakTunakTun];
    }
    else {
        self.gameType = EnumGameTicTacToe;
        [self sendTheGameType:TicTacToe];
    }
}

- (void)didReceiveDataWithNotification:(NSNotification *)notification {
    NSData *data = [[notification userInfo] objectForKey:@"data"];
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([stringData isEqualToString:TunakTunakTun]) {
            self.gameType = EnumGameTunakTunakTun;
        }
        else if ([stringData isEqualToString:TicTacToe]) {
            self.gameType = EnumGameTicTacToe;
        }
        else if ([stringData isEqualToString:self.firstPlayerName.text]) {
            self.playerOnTurn = self.firstPlayerName.text;
            self.isEngineSynchronized = true;
        }
        else if ([stringData isEqualToString:self.secondPlayerName.text] && [self.playerOnTurn isEqualToString:@""]) {
            self.playerOnTurn = self.secondPlayerName.text;
            self.isEngineSynchronized = true;
        }
        else {
            self.secondPlayerName.text = stringData;
        };
    });
    
}

@end
