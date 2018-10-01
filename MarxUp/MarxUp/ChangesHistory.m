//
//  ChangesHistory.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 19.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ChangesHistory.h"

@interface ChangesHistory ()

@property (strong, nonatomic)NSMutableArray *visibleChanges;
@property (strong, nonatomic)NSMutableArray *invisibleChanges;

@end

@implementation ChangesHistory

+ (instancetype)newWithChangeType:(Class)changeType {
    ChangesHistory *new = [[ChangesHistory alloc] init];
    if (new) {
        new.visibleChanges = @[].mutableCopy;
        new.invisibleChanges = @[].mutableCopy;
        new.singleChangeType = changeType;
    }
    return new;
}

- (void)undoChange {
    id lastChange = [self.visibleChanges lastObject];
    if (lastChange) {
        [self.invisibleChanges addObject:lastChange];
        [self.visibleChanges removeLastObject];
    }
}

- (void)redoChange {
    id lastDiscardedChange = [self.invisibleChanges lastObject];
    if (lastDiscardedChange) {
        [self.visibleChanges addObject:lastDiscardedChange];
        [self.invisibleChanges removeLastObject];
    }
}

- (void)cleanAllChanges {
    self.visibleChanges = @[].mutableCopy;
    self.invisibleChanges = @[].mutableCopy;
}

- (void)addChange:(id)change {
    if ([change isKindOfClass:self.singleChangeType]) {
        [self.visibleChanges addObject:change];
    }
}

- (NSArray *)getAllChanges {
    return self.visibleChanges;
}

- (BOOL)couldRedo {
    return self.invisibleChanges.count > 0;
}

- (BOOL)couldUndo {
    return self.visibleChanges.count > 0;
}

@end
