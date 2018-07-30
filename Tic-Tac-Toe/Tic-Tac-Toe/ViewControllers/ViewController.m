//
//  ViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ViewController.h"
#import "SinglePlayerViewController.h"
#import "MultiplePlayersViewController.h"
#import "ScoreboardTableViewController.h"
#import "ConnectionsViewController.h"

#import "Utilities.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSinglePlayerTap:(id)sender {
    SinglePlayerViewController *playerViewController = (SinglePlayerViewController *)[Utilities viewControllerWithClass:SinglePlayerViewController.class];
    [self.navigationController pushViewController:playerViewController animated:YES];
}

- (IBAction)onMultiplePlayers:(id)sender {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Choose to play locally or connect to the other player's device."
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* locally = [UIAlertAction
                                actionWithTitle:@"Play on this device" style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    MultiplePlayersViewController *playersViewController = (MultiplePlayersViewController *)[Utilities viewControllerWithClass:MultiplePlayersViewController.class];
                                    playersViewController.gameMode = EnumGameModeOneDevice;
                                    [self.navigationController pushViewController:playersViewController animated:YES];
                                }];
    
    UIAlertAction* connect = [UIAlertAction
                               actionWithTitle:@"Connect" style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   ConnectionsViewController *connectionsViewController = (ConnectionsViewController *)[Utilities viewControllerWithClass:ConnectionsViewController.class];
                                   [self.navigationController pushViewController:connectionsViewController animated:YES];
                               }];
    
    [alert addAction:locally];
    [alert addAction:connect];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onScoreboardTap:(id)sender {
    ScoreboardTableViewController *scoreboardViewController = (ScoreboardTableViewController *)[Utilities viewControllerWithClass:ScoreboardTableViewController.class];
    [self.navigationController pushViewController:scoreboardViewController animated:YES];
}

@end
