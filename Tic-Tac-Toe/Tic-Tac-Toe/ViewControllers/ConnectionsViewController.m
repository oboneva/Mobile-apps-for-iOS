//
//  ConnectionsViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 27.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "AppDelegate.h"

#import "ConnectionsViewController.h"
#import "MultiplePlayersViewController.h"

#import "Constants.h"
#import "Utilities.h"

@interface ConnectionsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *devicesFoundTableView;
@property (weak, nonatomic) IBOutlet UISwitch *visibilitySwitch;
@property (strong, nonatomic) NSMutableArray<MCPeerID *> *connectedPeers;
@property (strong, nonatomic) MCPeerID *selectedPeer;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;

@end

@implementation ConnectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MultipeerConectivityManager.sharedInstance setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [MultipeerConectivityManager.sharedInstance advertiseSelf:true];
    self.deviceNameTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeStateWithNotification:) name:NOTIFICATION_CHANGED_STATE object:nil];
    self.connectedPeers = [[NSMutableArray alloc] init];
    self.devicesFoundTableView.dataSource = self;
    self.devicesFoundTableView.delegate = self;
    [self.continueButton setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connectedPeers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_DEVICE_CELL forIndexPath:indexPath];
    
    cell.textLabel.text = self.connectedPeers[indexPath.row].displayName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedPeer = self.connectedPeers[indexPath.row];
    if (self.connectedPeers.count > 0) {
        [self.continueButton setHidden:NO];
    }
}

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    MCSessionState sessionState = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (sessionState == MCSessionStateConnected) {
        [self.connectedPeers addObject:peerID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                [self.devicesFoundTableView reloadData];
            }];
        });
    }
    else if (sessionState == MCSessionStateNotConnected && self.connectedPeers.count > 0) {
        [self.connectedPeers removeObject:peerID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.devicesFoundTableView reloadData];
        });
    }
}

- (IBAction)onVisibilityTap:(id)sender {
    [MultipeerConectivityManager.sharedInstance advertiseSelf:self.visibilitySwitch.isOn];
}

- (IBAction)onBrowseTap:(id)sender {
    [MultipeerConectivityManager.sharedInstance setupMCBrowser];
    [MultipeerConectivityManager.sharedInstance.browser setDelegate:self];
    [self.navigationController presentViewController:MultipeerConectivityManager.sharedInstance.browser animated:YES completion:nil];
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [MultipeerConectivityManager.sharedInstance.browser dismissViewControllerAnimated:YES completion:nil];
    if (self.connectedPeers.count > 0) {
        [self.continueButton setHidden:NO];
    }
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [MultipeerConectivityManager.sharedInstance.browser dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.deviceNameTextField resignFirstResponder];
    
    MultipeerConectivityManager.sharedInstance.peerID = nil;
    MultipeerConectivityManager.sharedInstance.session = nil;
    MultipeerConectivityManager.sharedInstance.browser = nil;
    
    if ([self.visibilitySwitch isOn]) {
        [MultipeerConectivityManager.sharedInstance.advertiser stop];
    }
    
    [MultipeerConectivityManager.sharedInstance setupPeerAndSessionWithDisplayName:self.deviceNameTextField.text];
    [MultipeerConectivityManager.sharedInstance setupMCBrowser];
    [MultipeerConectivityManager.sharedInstance advertiseSelf:self.visibilitySwitch.isOn];
    
    return YES;
}

- (IBAction)onContinueTap:(id)sender {
    MultiplePlayersViewController *playersViewController = (MultiplePlayersViewController *)[Utilities viewControllerWithClass:MultiplePlayersViewController.class];
    playersViewController.gameMode = EnumGameModeTwoDevices;
    playersViewController.peer = self.selectedPeer;
    [self.navigationController pushViewController:playersViewController animated:YES];
}

@end
