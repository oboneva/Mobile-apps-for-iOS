//
//  ScoreboardTableViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 25.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ScoreboardTableViewController.h"

#import "ScoreboardTableViewCell.h"
#import "LostGamesTableViewCell.h"

#import "LostGamesDataModel.h"

#import "Constants.h"
#import "UserDefaultsManager.h"

@interface ScoreboardTableViewController ()

@property (strong, nonatomic) NSDictionary *scoreboardData;
@property (strong, nonatomic) NSArray *lostGamesData;
@property (strong, nonatomic) NSArray *playersNamesFromScoreboard;

@end

@implementation ScoreboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setUserInteractionEnabled:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.scoreboardData = [defaults dictionaryForKey:HUMAN_SCORES_KEY];
    self.playersNamesFromScoreboard = [self.scoreboardData keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber *a, NSNumber *b) {
        return [b compare:a];
    }];
    
    self.lostGamesData = [UserDefaultsManager loadCustomObject];
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
    if (section == 0) {
        return self.playersNamesFromScoreboard.count + 1;
    }
    else {
        return self.lostGamesData.count + 1;
    }
}

- (UITableViewCell *)customizeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ScoreboardTableViewCell *scoreboardCell = (ScoreboardTableViewCell *)cell;
        scoreboardCell.rankLabel.text = [NSString stringWithFormat:@"%d.", indexPath.row];
        scoreboardCell.nameLabel.text = self.playersNamesFromScoreboard[indexPath.row - 1];
        [scoreboardCell.nameLabel sizeToFit];
        scoreboardCell.pointsLabel.text = [self.scoreboardData[self.playersNamesFromScoreboard[indexPath.row - 1]] stringValue];
        
        cell = scoreboardCell;
    }
    else {
        LostGamesTableViewCell *lostGameCell = (LostGamesTableViewCell *)cell;
        LostGamesDataModel *model = self.lostGamesData[indexPath.row - 1];
        lostGameCell.playerName.text = model.playerName;
        lostGameCell.BotName.text = model.botName;
        lostGameCell.numberOfLostGames.text = [NSString stringWithFormat:@"%d", model.countOfGamesLost ];
        cell = lostGameCell;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_SCOREBOARD_CELL forIndexPath:indexPath];
        ScoreboardTableViewCell *scoreboardCell = (ScoreboardTableViewCell *)cell;
        if (indexPath.row == 0) {
            scoreboardCell.rankLabel.text = @"Rank";
            scoreboardCell.pointsLabel.text = @"Score";
            scoreboardCell.nameLabel.text = @"Name";
        }
        else {
            [self customizeCell:scoreboardCell atIndexPath:indexPath];
        }
        cell = scoreboardCell;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_LOST_GAMES_CELL forIndexPath:indexPath];
        LostGamesTableViewCell *lostGameCell = (LostGamesTableViewCell *)cell;
        if (indexPath.row == 0) {
            lostGameCell.playerName.text = @"Player";
            lostGameCell.BotName.text = @"Lost from";
            lostGameCell.numberOfLostGames.text = @"Lost games";
            [lostGameCell.numberOfLostGames sizeToFit];
        }
        else {
            [self customizeCell:lostGameCell atIndexPath:indexPath];
        }
        cell = lostGameCell;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Ranking";
    }
    else {
        return @"Wall of Shame";
    }
}

@end
