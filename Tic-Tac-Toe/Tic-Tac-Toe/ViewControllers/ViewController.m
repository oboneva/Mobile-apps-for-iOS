//
//  ViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ViewController.h"
#import "GameTypeViewController.h"
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

- (IBAction)onNewGameTap:(id)sender {
    GameTypeViewController *gameTypeController = (GameTypeViewController *)[Utilities viewControllerWithClass:GameTypeViewController.class];
    [self. navigationController pushViewController:gameTypeController animated:YES];
}


- (IBAction)onScoreboardTap:(id)sender {
    ScoreboardTableViewController *scoreboardViewController = (ScoreboardTableViewController *)[Utilities viewControllerWithClass:ScoreboardTableViewController.class];
    [self.navigationController pushViewController:scoreboardViewController animated:YES];
}

@end
