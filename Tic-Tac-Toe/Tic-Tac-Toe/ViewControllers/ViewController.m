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
    MultiplePlayersViewController *playersViewController = (MultiplePlayersViewController *)[Utilities viewControllerWithClass:MultiplePlayersViewController.class];
    [self.navigationController pushViewController:playersViewController animated:YES];
}

- (IBAction)onScoreboardTap:(id)sender {
    ScoreboardTableViewController *scoreboardViewController = (ScoreboardTableViewController *)[Utilities viewControllerWithClass:ScoreboardTableViewController.class];
    [self.navigationController pushViewController:scoreboardViewController animated:YES];
}

@end
