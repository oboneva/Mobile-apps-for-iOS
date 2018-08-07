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

@interface JoinRoomViewController () <UITextFieldDelegate, PeerSearchDelegate, PeerSessionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *rooms;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *roomsFoundSectionHeader;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property (assign) EnumGame gameType;
@property (strong, nonatomic) NSMutableDictionary<MCPeerID *, NSDictionary *> *roomsFound;
@property (strong, nonatomic) NSMutableArray<MCPeerID *> *peers;
@property (strong, nonatomic) MCPeerID *peerToJoin;

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
    
    [self.activityIndicator hidesWhenStopped];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.joinButton setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    MultipeerConectivityManager.sharedInstance.peerSearchDelegate = self;
    MultipeerConectivityManager.sharedInstance.peerSessionDelegate = self;
    [MultipeerConectivityManager.sharedInstance startBrowsing];
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.roomsFoundSectionHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.roomsFoundSectionHeader.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.joinButton setHidden:NO];
    self.peerToJoin = self.peers[indexPath.row];
}

- (void)createEngineWithSecondPlayer:(NSString *)secondPlayer andPlayerOnTurn:(NSString *)playerOnTurn {
    GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];

    dispatch_async(dispatch_get_main_queue(), ^{
        HumanModel *player1 = [[HumanModel alloc] initWithName:self.playerNameTextField.text];
        HumanModel *player2 = [[HumanModel alloc] initWithName:secondPlayer];
        
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
        
        [MultipeerConectivityManager.sharedInstance stopBrowsing];
        MultipeerConectivityManager.sharedInstance.peerSearchDelegate = nil;
        MultipeerConectivityManager.sharedInstance.peerSessionDelegate = nil;
        
        [self.activityIndicator stopAnimating];
        [self.navigationController pushViewController:gameController animated:YES];

    });
}

- (IBAction)onJoinTap:(id)sender {
    [self.activityIndicator startAnimating];
    [MultipeerConectivityManager.sharedInstance invitePeer:self.peerToJoin];
}

- (void)didFoundPeer:(MCPeerID *)peerID withInfo:(NSDictionary *)info {
    NSString *gameName = TIC_TAC;
    if (self.gameType == EnumGameTunakTunakTun) {
        gameName = TUNAK_TUNAK;
    }
    
    if ([[info objectForKey:@"gameName"] isEqualToString:gameName]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.roomsFound[peerID] = info;
            [self.peers addObject:peerID];
            [self.rooms reloadData];
        });
    }
}

- (void)didLostPeer:(MCPeerID *)peerID {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.roomsFound removeObjectForKey:peerID];
        [self.peers removeObject:peerID];
        [self.rooms reloadData];
    });
}

- (void)peer:(MCPeerID *)peerID changedState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dataDict = @{KEY_NAME: self.playerNameTextField.text};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
            [MultipeerConectivityManager.sharedInstance sendData:data toPeer:self.peerToJoin];
        });
        
    }
}

- (void)didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    [self createEngineWithSecondPlayer:dataDict[KEY_NAME] andPlayerOnTurn:dataDict[KEY_TURN]];
}

@end
