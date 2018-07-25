//
//  ScoreboardTableViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 25.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ScoreboardTableViewController.h"

#import "ScoreboardTableViewCell.h"

#import "Constants.h"

@interface ScoreboardTableViewController ()

@property (strong, nonatomic) NSDictionary *scoreboardData;
@property (strong, nonatomic) NSArray *playersNames;

@end

@implementation ScoreboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setUserInteractionEnabled:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.scoreboardData = [defaults dictionaryForKey:SCORES_KEY];
    self.playersNames = [self.scoreboardData keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber *a, NSNumber *b) {
        return [b compare:a];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SCOREBOARD_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playersNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_SCOREBOARD_CELL forIndexPath:indexPath];
    
    cell.rankLabel.text = [NSString stringWithFormat:@"%d.", indexPath.row + 1];
    cell.nameLabel.text = self.playersNames[indexPath.row];
    [cell.nameLabel sizeToFit];
    cell.pointsLabel.text = [self.scoreboardData[self.playersNames[indexPath.row]] stringValue];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Ranking";
}


@end
