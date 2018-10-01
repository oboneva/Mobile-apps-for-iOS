//
//  ShapeModel.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 26.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShapeModel : NSObject

+(instancetype)newShapeFromType:(ShapeType)type;
@property (strong, nonatomic, readonly) UIImage *image;
@property (assign)ShapeType type;

@end

NS_ASSUME_NONNULL_END
