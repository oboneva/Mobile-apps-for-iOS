//
//  ChangesHistory.h
//  MarxUp
//
//  Created by Ognyanka Boneva on 19.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangesHistory : NSObject

@property (strong, nonatomic) Class singleChangeType;

+ (instancetype)newWithChangeType:(Class)changeType;

- (BOOL)undoChange;
- (BOOL)redoChange;
- (void)cleanAllChanges;
- (void)addChange:(id)change;

- (NSArray *)getAllChanges;
- (id)lastChange;
- (id)lastInvisibleChange;

@end

NS_ASSUME_NONNULL_END
