//
//  ArrowModel.h
//  MarxUp
//
//  Created by A-Team User on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArrowModel : NSObject

+ (instancetype)newArrowFromType:(ArrowEndLineType)type;
@property (strong, nonatomic, readonly) UIImage *image;
@property (assign)ArrowEndLineType type;

@end

NS_ASSUME_NONNULL_END
