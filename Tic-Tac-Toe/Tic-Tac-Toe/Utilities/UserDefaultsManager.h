//
//  UserDefaultsManager.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LostGamesDataModel;

@interface UserDefaultsManager : NSObject

+ (void)saveCustomObject:(NSArray<LostGamesDataModel *>*)data;
+ (NSArray<LostGamesDataModel *>*)loadCustomObject;

@end
