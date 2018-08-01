//
//  FoundGameTableViewCell.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 1.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundGameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *playersCount;

@end
