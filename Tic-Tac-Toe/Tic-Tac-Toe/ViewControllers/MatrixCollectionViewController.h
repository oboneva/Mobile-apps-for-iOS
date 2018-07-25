//
//  MatrixCollectionViewController.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 16.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"
#import "Constants.h"

@class GameEngine;
@interface MatrixCollectionViewController : UICollectionViewController

@property (weak, nonatomic)id<NotifyPlayerToPlayDelegate>notifyPlayerToPlayDelegate;
@property (weak, nonatomic)id<EndGameDelegate>endGameDelegate;
@property (strong, nonatomic) GameEngine *engine;

@end
