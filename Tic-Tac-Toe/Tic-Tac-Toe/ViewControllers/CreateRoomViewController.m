//
//  CreateRoomViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 1.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "CreateRoomViewController.h"
#import "GameViewController.h"
#import "NetworkGameViewController.h"

#import "HumanModel.h"

#import "GameEngine.h"

#import "MultipeerConectivityManager.h"
#import "Constants.h"
#import "Utilities.h"

#define TIC_TAC          @"Tic-Tac-Toe"
#define TUNAK_TUNAK      @"Tunak-Tunak-Tun"
#define DISPLAY_NAME     @".game"
#define QUESTION         @"What is your name?"
#define UNKNOWN_APP      @"unknown"
#define ROOM_NAME        @"roomName"
#define GAME_NAME        @"gameName"
#define ALL_PLAYERS      @"appPlayers"
#define CURRENT_PLAYERS  @"currentPlayers"
#define TIC_TAC_TOE_PLAYERS @"2"
#define DEFAULT_PLAYER_NAME @"Player"

@interface CreateRoomViewController () <UITextFieldDelegate, PeerSessionDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) GameEngine *engine;
@property (assign) EnumGame gameType;

@end

@implementation CreateRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *displayName = [[UIDevice currentDevice].name stringByAppendingString:DISPLAY_NAME];
    [MultipeerConectivityManager.sharedInstance setupPeerAndSessionWithDisplayName:displayName];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.playerNameTextField.delegate = self;
    self.roomNameTextField.delegate = self;
    
    MultipeerConectivityManager.sharedInstance.peerSessionDelegate = self;
    
    [self.activityIndicator hidesWhenStopped];
    [self.activityIndicator setHidesWhenStopped:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:NetworkGameViewController.class]) { //back button is pressed
        [MultipeerConectivityManager.sharedInstance stopAdvertising];
        [MultipeerConectivityManager.sharedInstance disconnectPeer];
    }
}

- (void)createEngine {
    HumanModel *player1 = [[HumanModel alloc] initWithName:self.playerNameTextField.text];
    HumanModel *player2 = [[HumanModel alloc] initWithName:DEFAULT_PLAYER_NAME];
    
    GameEngine *engine = [Utilities gameEngineFromType:self.gameType];
    engine.player1 = player1;
    engine.player2 = player2;
    [engine setUpPlayers];
    
    self.engine = engine;
}

- (void)startGameWithPeer:(MCPeerID *)peerID andOtherPlayerApp:(NSString *)appName{
    GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];
    [gameController setEngine:self.engine];
    gameController.gameMode = EnumGameModeTwoDevices;
    gameController.gameType = self.gameType;
    gameController.peer = peerID;
    gameController.roomBelongsToMe = true;
    gameController.otherPlayerAppName = appName;
    
    MultipeerConectivityManager.sharedInstance.peerSessionDelegate = nil;
    [self.activityIndicator stopAnimating];
    [self.navigationController pushViewController:gameController animated:YES];
}

- (IBAction)onCreateTap:(id)sender {
    [self.activityIndicator startAnimating];
    
    NSString *gameName = TIC_TAC;
    if (self.gameType == EnumGameTunakTunakTun) {
        gameName = TUNAK_TUNAK;
    }
    NSDictionary *discoveryInfo = @{ROOM_NAME : self.roomNameTextField.text, GAME_NAME : gameName, CURRENT_PLAYERS : @"1", ALL_PLAYERS : TIC_TAC_TOE_PLAYERS};
    [MultipeerConectivityManager.sharedInstance startAdvertisingWithDiscoveryInfo:discoveryInfo];
    [self createEngine];
}

- (void)peer:(MCPeerID *)peerID changedState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        [self sendQuestion:QUESTION toPeer:peerID];
    }
}

- (void)sendInfoToConnectedPeer:(MCPeerID *)peerID {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dataDict = @{KEY_TURN : self.engine.currentPlayer.name, KEY_NAME : self.playerNameTextField.text};
        [self sendDataWithDictionary:dataDict toPeer:peerID];
    });
}

- (void)sendQuestion:(NSString *)string toPeer:(MCPeerID *)peerID {
    NSDictionary *dataDict = @{KEY_QUESTION : string};
    [self sendDataWithDictionary:dataDict toPeer:peerID];
}

- (void)sendDataWithDictionary:(NSDictionary *)dictionary toPeer:(MCPeerID *)peerID {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    [MultipeerConectivityManager.sharedInstance sendData:data toPeer:peerID];
}

- (void)didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dataDict objectForKey:KEY_NAME]) {
            self.engine.player2.name = dataDict[KEY_NAME];
        }
        
        NSString *otherPlayerAppName = EMPTY_TEXT;
        if ([dataDict objectForKey:KEY_APP]) {
            otherPlayerAppName = THIS_APP_NAME;
            [self sendInfoToConnectedPeer:peerID];
        }
        [MultipeerConectivityManager.sharedInstance stopAdvertising];
        [self startGameWithPeer:peerID andOtherPlayerApp:otherPlayerAppName];
    });
}

@end
