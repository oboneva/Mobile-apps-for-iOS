//
//  GameModeViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 1.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "GameModeViewController.h"
#import "EnemyTypeViewController.h"
#import "NetworkGameViewController.h"
#import "SinglePlayerViewController.h"

#import "Constants.h"
#import "Utilities.h"

@interface SinglePlayerViewController ()
@property (assign) EnumGame gameType;

@end

@interface EnemyTypeViewController ()
@property (assign) EnumGame gameType;

@end

@interface NetworkGameViewController ()
@property (assign) EnumGame gameType;

@end

@interface GameModeViewController ()

@property (assign) EnumGame gameType;

@end

@implementation GameModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLocalGameTap:(id)sender {
    if (self.gameType == EnumGameBattleships) {
        SinglePlayerViewController *singlePlayerController = (SinglePlayerViewController *)[Utilities viewControllerWithClass:SinglePlayerViewController.class];
        singlePlayerController.gameType = self.gameType;
        [self.navigationController pushViewController:singlePlayerController animated:YES];
    }
    else {
        EnemyTypeViewController *enemyTypeController = (EnemyTypeViewController *)[Utilities viewControllerWithClass:EnemyTypeViewController.class];
        enemyTypeController.gameType = self.gameType;
        [self.navigationController pushViewController:enemyTypeController animated:YES];
    }
}

- (IBAction)onNetworkGameTap:(id)sender {
    NetworkGameViewController *networkGameController = (NetworkGameViewController *)[Utilities viewControllerWithClass:NetworkGameViewController.class];
    networkGameController.gameType = self.gameType;
    [self.navigationController pushViewController:networkGameController animated:YES];
}

@end
