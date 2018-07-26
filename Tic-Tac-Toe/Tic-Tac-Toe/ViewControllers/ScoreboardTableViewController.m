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
@property (strong, nonatomic) IBOutlet UIView *loserSectionHeader;
@property (strong, nonatomic) IBOutlet UIView *winnerSectionHeader;

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
        return self.playersNamesFromScoreboard.count;
    }
    else {
        return self.lostGamesData.count;
    }
}

- (UITableViewCell *)customizeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ScoreboardTableViewCell *scoreboardCell = (ScoreboardTableViewCell *)cell;
        scoreboardCell.rankLabel.text = [NSString stringWithFormat:@"%d.", indexPath.row + 1];
        scoreboardCell.nameLabel.text = self.playersNamesFromScoreboard[indexPath.row];
        [scoreboardCell.nameLabel sizeToFit];
        scoreboardCell.pointsLabel.text = [self.scoreboardData[self.playersNamesFromScoreboard[indexPath.row]] stringValue];
        
        cell = scoreboardCell;
    }
    else {
        LostGamesTableViewCell *lostGameCell = (LostGamesTableViewCell *)cell;
        LostGamesDataModel *model = self.lostGamesData[indexPath.row];
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
        [self customizeCell:scoreboardCell atIndexPath:indexPath];
        
        cell = scoreboardCell;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_LOST_GAMES_CELL forIndexPath:indexPath];
        LostGamesTableViewCell *lostGameCell = (LostGamesTableViewCell *)cell;
        [self customizeCell:lostGameCell atIndexPath:indexPath];
        cell = lostGameCell;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.winnerSectionHeader;
    }
    return self.loserSectionHeader;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return self.sectionHeader.frame.size.height;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return @"Ranking";
//    }
//    else {
//        return @"Wall of Shame";
//    }
//}

@end
