//
//  GameTypeViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 1.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "GameTypeViewController.h"
#import "GameModeViewController.h"

#import "Utilities.h"
#import "Constants.h"

@interface GameModeViewController ()

@property (assign) EnumGame gameType;

@end


@interface GameTypeViewController ()

@end

@implementation GameTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTicTap:(id)sender {
    [self continueGameCreationWithGame:EnumGameTicTacToe];
}

- (IBAction)onTunakTap:(id)sender {
    [self continueGameCreationWithGame:EnumGameTunakTunakTun];
}

- (IBAction)onBattleshipsTap:(id)sender {
    [self continueGameCreationWithGame:EnumGameBattleships];
}

- (void)continueGameCreationWithGame:(EnumGame)gameType {
    GameModeViewController *gameModeController = (GameModeViewController *)[Utilities viewControllerWithClass:GameModeViewController.class];
    gameModeController.gameType = gameType;
    [self.navigationController pushViewController:gameModeController animated:YES];
}

@end
