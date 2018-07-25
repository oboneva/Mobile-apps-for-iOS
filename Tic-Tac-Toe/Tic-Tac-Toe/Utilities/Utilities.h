//
//  Utilities.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface Utilities : NSObject

+ (int)randomNumberWithUpperBound:(int)upperBound;
+ (UIViewController *) viewControllerWithClass:(Class)class;
+ (id)gameEngineFromType:(EnumGame)type;

@end
