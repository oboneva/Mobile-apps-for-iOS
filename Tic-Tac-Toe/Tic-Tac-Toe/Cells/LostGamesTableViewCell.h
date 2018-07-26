//
//  LostGamesTableViewCell.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostGamesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UILabel *BotName;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLostGames;

@end
