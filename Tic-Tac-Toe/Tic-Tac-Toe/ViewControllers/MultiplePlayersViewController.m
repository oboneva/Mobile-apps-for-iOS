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
#import "Constants.h"

@interface MultiplePlayersViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstPlayerName;
@property (weak, nonatomic) IBOutlet UITextField *secondPlayerName;
@property (assign) EnumGame gameType;
@property (assign) EnumGameMode gameMode;
//@property (assign) BOOL isEngineSynchronized;
//@property (assign) BOOL isOtherReceiving;
//@property (assign) BOOL isOtherReadyToPlay;
//@property (strong, nonatomic) NSString *playerOnTurn;
//@property (strong, nonatomic) NSMutableArray<NSData *> *infoToSend;
@property (strong, nonatomic) GameViewController *nextController;
@end

@implementation MultiplePlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    self.playerOnTurn = @"";
    self.infoToSend = [[NSMutableArray alloc]init];
    self.isOtherReceiving = false;
    self.isOtherReadyToPlay = false;
    */
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.firstPlayerName.delegate = self;
    self.secondPlayerName.delegate = self;
    
    /*
    self.isEngineSynchronized = false;
    if (self.gameMode == EnumGameModeTwoDevices) {
        [self.secondPlayerName setHidden:YES];
    }
    
    [self sendState];
     */
}

- (void)viewDidAppear:(BOOL)animated {
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDataWithNotification:) name:NOTIFICATION_RECEIVE_DATA object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    /*
    if (self.gameMode == EnumGameModeTwoDevices) {
        [self sendMyNameToTheOtherPlayer];
    }
     */
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    /*
    if (self.gameMode == EnumGameModeTwoDevices) {
        [self sendMyNameToTheOtherPlayer];
    }*/
    return YES;
}
/*
- (void)sendState {
    NSString *string = [[NSString alloc] initWithFormat:@"%ld - %ld", EnumSendDataState, EnumReadyToListen];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *peers = @[self.peer];
    NSError *error;
    [MultipeerConectivityManager.sharedInstance.session sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:&
     error];
}

- (void)sendReadyToPlay {
    NSString *string = [[NSString alloc] initWithFormat:@"%ld - %ld", EnumSendDataState, EnumReadyToPlay];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}

- (void)sendMyNameToTheOtherPlayer {
    NSString *string = [[NSString alloc] initWithFormat:@"%ld - %@", EnumSendDataName, self.firstPlayerName.text];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}

- (void)sendGameType:(NSInteger)gameType {
    NSString *string = [[NSString alloc] initWithFormat:@"%ld - %ld", EnumSendDataGame, gameType];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}

- (void)sendTheFirstPlayerOnTurn:(NSString *)playerName {
    NSString *string = [[NSString alloc] initWithFormat:@"%ld - %@", EnumSendDataTurn, playerName];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}

- (void)sendData:(NSData *)data {
    if (self.isOtherReceiving) {
        NSArray *peers = @[self.peer];
        NSError *error;
        [MultipeerConectivityManager.sharedInstance.session sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:&
         error];
    }
    else {
        [self.infoToSend addObject:data];
    }
    
}
*/
- (IBAction)onPlayTap:(id)sender {
    //[self sendReadyToPlay];
    GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];
    HumanModel *player1 = [[HumanModel alloc] initWithName:self.firstPlayerName.text];
    HumanModel *player2 = [[HumanModel alloc] initWithName:self.secondPlayerName.text];
    
    GameEngine *engine = [Utilities gameEngineFromType:self.gameType];
    engine.player1 = player1;
    engine.player2 = player2;
    //gameController.peer = self.peer;
    /*
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
    */
    [gameController setEngine:engine];
    
    gameController.gameMode = self.gameMode;
    gameController.gameType = self.gameType;
    /*
    if (self.isOtherReadyToPlay && self.infoToSend.count == 0) {
        [self startTheGameWithController:gameController];
    }
    else {
        self.nextController = gameController;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Waiting for the other player..." message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }*/
    [self.navigationController pushViewController:gameController animated:YES];
}
/*
- (void)startTheGameWithController:(GameViewController *)controller {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (![[self.navigationController.viewControllers lastObject] isMemberOfClass:MultiplePlayersViewController.class]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController pushViewController:controller animated:YES];
}*/
/*
- (void)sendInfoFromQueue {
    NSArray *peers = @[self.peer];
    NSError *error;
    for (NSData *data in self.infoToSend) {
        [MultipeerConectivityManager.sharedInstance.session sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:&
         error];
    }
    [self.infoToSend removeAllObjects];
}

- (void)didReceiveDataWithNotification:(NSNotification *)notification {
    NSData *data = [[notification userInfo] objectForKey:@"data"];
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *stringComponents = [stringData componentsSeparatedByString:DATA_SEPARATOR];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([stringComponents.firstObject intValue] == EnumSendDataGame) {
            self.gameType = [stringComponents.lastObject intValue];
        }
        else if ([stringComponents.firstObject intValue] == EnumSendDataTurn) {
            self.playerOnTurn = stringComponents.lastObject;
            self.isEngineSynchronized = true;
        }
        else if([stringComponents.firstObject intValue] == EnumSendDataName) {
            self.secondPlayerName.text = stringComponents.lastObject;
        }
        else if([stringComponents.firstObject intValue] == EnumSendDataState && [stringComponents.lastObject intValue] == EnumReadyToListen) {
            self.isOtherReceiving = true;
            [self sendState];
            [self sendInfoFromQueue];
        }
        else if([stringComponents.firstObject intValue] == EnumSendDataState && [stringComponents.lastObject intValue] == EnumReadyToPlay) {
            self.isOtherReadyToPlay = true;
            if (self.nextController) {
                [self startTheGameWithController:self.nextController];
            }
        };
    });
    
}
*/
@end
