//
//  GameViewController.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "Constants.h"

@class GameEngine;
@interface GameViewController : UIViewController

@property (strong, nonatomic) GameEngine *engine;
@property (assign) EnumGameMode gameMode;
@property (assign) EnumGame gameType;
@property (strong, nonatomic) MCPeerID *peer;

@end
