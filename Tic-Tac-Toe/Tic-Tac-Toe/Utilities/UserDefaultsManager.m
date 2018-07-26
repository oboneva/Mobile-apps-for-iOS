//
//  UserDefaultsManager.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 26.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "UserDefaultsManager.h"
#import "Constants.h"

@class LostGamesDataModel;

@implementation UserDefaultsManager

+ (void)saveCustomObject:(NSArray<LostGamesDataModel *>*)data {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:data];
    [defaults setObject:myEncodedObject forKey:LOST_AGAINST_BOT_KEY];
}

+ (NSArray<LostGamesDataModel *>*)loadCustomObject {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:LOST_AGAINST_BOT_KEY];
    NSArray<LostGamesDataModel *> *obj = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    if (!obj) {
        obj = [[NSArray alloc] init];
    }
    return obj;
}

@end
