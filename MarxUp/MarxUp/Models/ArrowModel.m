//
//  ArrowModel.m
//  MarxUp
//
//  Created by A-Team User on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ArrowModel.h"

@interface ArrowModel ()

@property (strong, nonatomic, readwrite) UIImage *image;

@end

@implementation ArrowModel

+ (instancetype)newArrowFromType:(ArrowEndLineType)type {
    ArrowModel *new = [ArrowModel new];
    if (new) {
        new.type = type;
        new.image = [UIImage imageNamed:@""];
    }
    return new;
}

@end
