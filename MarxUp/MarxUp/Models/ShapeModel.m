//
//  ShapeModel.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 26.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ShapeModel.h"
#import "Utilities.h"

@interface ShapeModel ()

@property (strong, nonatomic, readwrite) UIImage *image;

@end

@implementation ShapeModel

+ (instancetype)newShapeFromType:(ShapeType)type {
    ShapeModel *newShape = [ShapeModel new];
    if (newShape) {
        newShape.type = type;
        newShape.image = [UIImage imageNamed:[NSString stringWithFormat:@"toolbox-shape-%@", [Utilities shapeTypeToString:type] ]];
    }
    return newShape;
}

@end
