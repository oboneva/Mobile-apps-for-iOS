//
//  EnemyTypeViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 1.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "EnemyTypeViewController.h"
#import "SinglePlayerViewController.h"
#import "MultiplePlayersViewController.h"

#import "Constants.h"
#import "Utilities.h"

@interface SinglePlayerViewController ()
@property (assign) EnumGame gameType;

@end

@interface MultiplePlayersViewController ()
@property (assign) EnumGame gameType;

@end

@interface EnemyTypeViewController ()

@property (assign) EnumGame gameType;
@property (assign) EnumGameMode gameMode;

@end

@implementation EnemyTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onEnemyBotTap:(id)sender {
    SinglePlayerViewController *singlePlayerController  = (SinglePlayerViewController *)[Utilities viewControllerWithClass:SinglePlayerViewController.class];
    singlePlayerController.gameType = self.gameType;
    [self.navigationController pushViewController:singlePlayerController animated:YES];
}

- (IBAction)onEnemyHumanTap:(id)sender {
    MultiplePlayersViewController *multiplePlayersController  = (MultiplePlayersViewController *)[Utilities viewControllerWithClass:MultiplePlayersViewController.class];
    multiplePlayersController.gameType = self.gameType;
    [self.navigationController pushViewController:multiplePlayersController animated:YES];
}

@end
