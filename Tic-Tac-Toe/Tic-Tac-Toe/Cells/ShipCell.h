//
//  ShipCell.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 22.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end
