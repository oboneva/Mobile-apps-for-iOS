//
//  DocumentPreviewTableViewCell.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 4.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentPreviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *documentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
