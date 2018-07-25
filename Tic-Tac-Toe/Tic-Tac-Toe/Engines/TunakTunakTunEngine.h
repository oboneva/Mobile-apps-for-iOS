//
//  TunakTunakTunEngine.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 24.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameEngine.h"

@class TunakTunakTunCellModel;
@interface TunakTunakTunEngine : GameEngine

- (TunakTunakTunCellModel *)getCellAtIndex:(NSIndexPath *)indexPath;

@end
