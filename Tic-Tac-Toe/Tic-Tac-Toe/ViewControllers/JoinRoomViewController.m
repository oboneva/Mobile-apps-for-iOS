//
//  JoinRoomViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 27.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "GameEngine.h"
#import "JoinRoomViewController.h"
#import "MultiplePlayersViewController.h"
#import "GameViewController.h"

#import "FoundGameTableViewCell.h"

#import "HumanModel.h"

#import "Constants.h"
#import "Utilities.h"
#import "MultipeerConectivityManager.h"

#define TIC_TAC      @"Tic-Tac-Toe"
#define TUNAK_TUNAK  @"Tunak-Tunak-Tun"

@interface JoinRoomViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *rooms;
@property (assign) EnumGame gameType;
@property (strong, nonatomic) NSMutableDictionary<MCPeerID *, NSDictionary *> *roomsFound;
@property (strong, nonatomic) NSMutableArray<MCPeerID *> *peers;
@property (strong, nonatomic) MCPeerID *peerToJoin;
@property (strong, nonatomic) NSString *otherPlayerName;

@end

@implementation JoinRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MultipeerConectivityManager.sharedInstance setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    //[self.view addGestureRecognizer:tap];
    self.playerNameTextField.delegate = self;
    
    self.rooms.dataSource = self;
    self.rooms.delegate = self;
    
    self.peers = [[NSMutableArray alloc] init];
    self.roomsFound = [[NSMutableDictionary alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [MultipeerConectivityManager.sharedInstance setupMCBrowser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomFound:) name:NOTIFICATION_PEER_FOUND object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomLost:) name:NOTIFICATION_PEER_LOST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveData:) name:NOTIFICATION_RECEIVE_DATA object:nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.roomsFound.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoundGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FOUND_GAME_CELL];
    
    NSDictionary *roomInfo = self.roomsFound[self.peers[indexPath.row]];
    cell.roomName.text = [roomInfo objectForKey:@"roomName"];
    cell.gameName.text = [roomInfo objectForKey:@"gameName"];
    cell.playersCount.text = [[NSString alloc] initWithFormat:@"%@/%@", [roomInfo objectForKey:@"currentPlayers"], [roomInfo objectForKey:@"allPlayers"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.peerToJoin = self.peers[indexPath.row];
}

- (void)roomFound:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSDictionary *room = [[notification userInfo] objectForKey:@"discoveryInfo"];
    
    NSString *gameName = TIC_TAC;
    if (self.gameType == EnumGameTunakTunakTun) {
        gameName = TUNAK_TUNAK;
    }
    
    if ([[room objectForKey:@"gameName"] isEqualToString:gameName]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.roomsFound[peerID] = room;
            [self.peers addObject:peerID];
            [self.rooms reloadData];
        });
    }
}

- (void)roomLost:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.roomsFound removeObjectForKey:peerID];
        [self.peers removeObject:peerID];
        [self.rooms reloadData];
    });
}

- (void)didReceiveData:(NSNotification *)notification {
    NSData *data = [[notification userInfo] objectForKey:@"data"];
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *stringComponents = [dataString componentsSeparatedByString:DATA_SEPARATOR];
    if ([stringComponents.firstObject intValue] == EnumSendDataTurn) {
        [self createEngineWithSecondPlayer:self.otherPlayerName andPlayerOnTurn:stringComponents.lastObject];
    }
    else if([stringComponents.firstObject intValue] == EnumSendDataName) {
        self.otherPlayerName = stringComponents.lastObject;
    }
}

- (void)createEngineWithSecondPlayer:(NSString *)secondPlayer andPlayerOnTurn:(NSString *)playerOnTurn {
    GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];
    HumanModel *player1 = [[HumanModel alloc] initWithName:self.playerNameTextField.text];
    HumanModel *player2 = [[HumanModel alloc] initWithName:@""];
    
    GameEngine *engine = [Utilities gameEngineFromType:self.gameType];
    engine.player1 = player1;
    engine.player2 = player2;
    
    if([playerOnTurn isEqualToString:player1.name]) {
        [engine customSetUpPlayersWithFirstPlayerOnTurn:player1];
    }
    else {
        [engine customSetUpPlayersWithFirstPlayerOnTurn:player2];
    }
    
    [gameController setEngine:engine];
    gameController.gameMode = EnumGameModeTwoDevices;
    gameController.gameType = self.gameType;
    gameController.peer = self.peerToJoin;
    gameController.roomBelongsToMe = false;
    
    [MultipeerConectivityManager.sharedInstance.browser stopBrowsingForPeers];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController pushViewController:gameController animated:YES];
}

- (IBAction)onJoinTap:(id)sender {
    NSData *data = [self.playerNameTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    MultipeerConectivityManager *mcManager = MultipeerConectivityManager.sharedInstance;
    [mcManager.browser invitePeer:self.peerToJoin toSession:mcManager.session withContext:data timeout:30];
}

@end
//didChangeState?????
