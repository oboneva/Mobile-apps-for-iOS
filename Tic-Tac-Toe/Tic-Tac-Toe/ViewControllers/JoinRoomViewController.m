//
//  JoinRoomViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 27.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "AppDelegate.h"

#import "JoinRoomViewController.h"
#import "MultiplePlayersViewController.h"

#import "Constants.h"
#import "Utilities.h"

@interface JoinRoomViewController ()
@property (assign) EnumGame gameType;

@end

@implementation JoinRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MultipeerConectivityManager.sharedInstance setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
*/



@end
