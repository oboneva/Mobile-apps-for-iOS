//
//  CreateRoomViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 1.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "CreateRoomViewController.h"
#import "GameViewController.h"

#import "HumanModel.h"

#import "GameEngine.h"

#import "MultipeerConectivityManager.h"
#import "Constants.h"
#import "Utilities.h"

#define TIC_TAC      @"Tic-Tac-Toe"
#define TUNAK_TUNAK  @"Tunak-Tunak-Tun"

@interface CreateRoomViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;
@property (strong, nonatomic) GameEngine *engine;
@property(strong, nonatomic) NSNotification *notf;

@property (assign) EnumGame gameType;

@end

@implementation CreateRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MultipeerConectivityManager.sharedInstance setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.playerNameTextField.delegate = self;
    self.roomNameTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeStateWithNotification:) name:NOTIFICATION_CHANGED_STATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerIsAboutToJoin:) name:NOTIFICATION_PEER_WILL_JOIN object:nil];
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

- (void)createEngine { /////////////////////////////////////////////////////////////////////////////////////
    HumanModel *player1 = [[HumanModel alloc] initWithName:self.playerNameTextField.text];
    HumanModel *player2 = [[HumanModel alloc] initWithName:@""];
    
    GameEngine *engine = [Utilities gameEngineFromType:self.gameType];
    engine.player1 = player1;
    engine.player2 = player2;
    [engine setUpPlayers];
    
    self.engine = engine;
}

- (void)startGameWithPeer:(MCPeerID *)peerID {
    GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];
    [gameController setEngine:self.engine];
    gameController.gameMode = EnumGameModeTwoDevices;
    gameController.gameType = self.gameType;
    gameController.peer = peerID;
    gameController.roomBelongsToMe = true;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushViewController:gameController animated:YES];
}

- (IBAction)onCreateTap:(id)sender {
    NSString *gameName = TIC_TAC;
    if (self.gameType == EnumGameTunakTunakTun) {
        gameName = TUNAK_TUNAK;
    }
    NSDictionary *discoveryInfo = @{@"roomName" : self.roomNameTextField.text, @"gameName" : gameName, @"currentPlayers" : @"1", @"allPlayers" : @"2"};
    [MultipeerConectivityManager.sharedInstance advertiseSelf:true withDiscoveryInfo:discoveryInfo];
    [self createEngine];
}

- (void)peerIsAboutToJoin:(NSNotification *)notification {
    MCPeerID *peer = [[notification userInfo] objectForKey:@"peerID"];
    NSData *data  = [[notification userInfo] objectForKey:@"playerName"];
    NSString *otherPlayerName = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.engine.player2.name = otherPlayerName;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *myName = [[NSString alloc] initWithFormat:@"%ld - %@", EnumSendDataName, self.playerNameTextField.text];
        NSData *dataName = [myName dataUsingEncoding:NSUTF8StringEncoding];
        NSString *turn = [[NSString alloc] initWithFormat:@"%ld - %@", EnumSendDataTurn, self.engine.currentPlayer.name];
        NSData *dataTurn = [turn dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *peers = @[peer];
        NSError *error;
        
        [MultipeerConectivityManager.sharedInstance.session sendData:dataName toPeers:peers withMode:MCSessionSendDataReliable error:&error];
        [MultipeerConectivityManager.sharedInstance.session sendData:dataTurn toPeers:peers withMode:MCSessionSendDataReliable error:&error];
        [MultipeerConectivityManager.sharedInstance advertiseSelf:NO withDiscoveryInfo:nil];
        
        [self startGameWithPeer:peer];
    });
}

@end
