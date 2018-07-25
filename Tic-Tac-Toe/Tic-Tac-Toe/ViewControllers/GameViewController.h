//
//  GameViewController.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class GameEngine;
@interface GameViewController : UIViewController

@property (strong, nonatomic) GameEngine *engine;

@end
