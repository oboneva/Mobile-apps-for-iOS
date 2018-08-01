//
//  NetworkGameViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 1.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "NetworkGameViewController.h"
#import "CreateRoomViewController.h"
#import "JoinRoomViewController.h"

#import "Utilities.h"
#import "Constants.h"

@interface JoinRoomViewController ()
@property (assign) EnumGame gameType;

@end

@interface CreateRoomViewController ()
@property (assign) EnumGame gameType;

@end

@interface NetworkGameViewController ()

@property (assign) EnumGame gameType;
@property (assign) EnumGameMode gameMode;

@end

@implementation NetworkGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCreateRoomTap:(id)sender {
    CreateRoomViewController *createRoomController = (CreateRoomViewController *)[Utilities viewControllerWithClass:CreateRoomViewController.class];
    createRoomController.gameType = self.gameType;
    [self.navigationController pushViewController:createRoomController animated:YES];
}

- (IBAction)onJoinRoomTap:(id)sender {
    JoinRoomViewController *joinRoomController = (JoinRoomViewController *)[Utilities viewControllerWithClass:JoinRoomViewController.class];
    joinRoomController.gameType = self.gameType;
}

@end
