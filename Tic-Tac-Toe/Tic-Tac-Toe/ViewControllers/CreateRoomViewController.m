//
//  CreateRoomViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 1.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "CreateRoomViewController.h"

#import "HumanModel.h"

#import "GameEngine.h"

#import "MultipeerConectivityManager.h"
#import "Constants.h"
#import "Utilities.h"

#define TIC_TAC      @"Tic-Tac-Toe"
#define TUNAK_TUNAK  @"Tunak-Tunak-Tun"

@interface CreateRoomViewController ()
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;
@property (strong, nonatomic) GameEngine *engine;

@property (assign) EnumGame gameType;

@end

@implementation CreateRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MultipeerConectivityManager.sharedInstance setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeStateWithNotification:) name:NOTIFICATION_CHANGED_STATE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createEngine {
    HumanModel *player1 = [[HumanModel alloc] initWithName:self.playerNameTextField.text];
    HumanModel *player2 = [[HumanModel alloc] initWithName:@""];
    
    GameEngine *engine = [Utilities gameEngineFromType:self.gameType];
    engine.player1 = player1;
    engine.player2 = player2;
    
    self.engine = engine;
}

- (IBAction)onCreateTap:(id)sender {
    /*
    NSString *gameName = TIC_TAC;
    if (self.gameType == EnumGameTunakTunakTun) {
        gameName = TUNAK_TUNAK;
    }
    NSDictionary *discoveryInfo = @{@"roomName" : self.roomNameTextField.text, @"gameName" : gameName, @"currentPlayers" : @1, @"allPlayers" : @2};
    [MultipeerConectivityManager.sharedInstance advertiseSelf:true withDiscoveryInfo:discoveryInfo];
     */
}

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification {
    //MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    MCSessionState sessionState = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (sessionState == MCSessionStateConnected) {
        [self createEngine];
    }
}

@end
//GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];

//[gameController setEngine:engine];
//gameController.gameMode = EnumGameModeOneDevice;
//gameController.gameType = self.gameType;
