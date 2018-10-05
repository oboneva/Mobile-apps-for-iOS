//
//  ArrowModel.m
//  MarxUp
//
//  Created by A-Team User on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ArrowModel.h"
#import "Utilities.h"

@interface ArrowModel ()

@property (strong, nonatomic, readwrite) UIImage *image;

@end

@implementation ArrowModel

+ (instancetype)newArrowFromType:(ArrowEndLineType)type {
    ArrowModel *new = [ArrowModel new];
    if (new) {
        new.type = type;
        new.image = [UIImage imageNamed:[NSString stringWithFormat:@"toolbox-arrow-%@", [Utilities arrowTypeToString:type]]];
    }
    return new;
}

@end
