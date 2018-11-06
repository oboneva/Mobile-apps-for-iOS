//
//  ChangesHistory.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 19.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ChangesHistory.h"

@interface ChangesHistory ()

@property (strong, nonatomic) NSMutableArray *visibleChanges;
@property (strong, nonatomic) NSMutableArray *invisibleChanges;

@end

@implementation ChangesHistory

+ (instancetype)newWithChangeType:(Class)changeType {
    ChangesHistory *new = [ChangesHistory new];
    if (new) {
        new.visibleChanges = @[].mutableCopy;
        new.invisibleChanges = @[].mutableCopy;
        new.singleChangeType = changeType;
    }
    return new;
}

- (BOOL)undoChange {
    if (self.visibleChanges.count == 0) {
        return false;
    }
    
    
    id lastChange = [self.visibleChanges lastObject];
    if (lastChange) {
        [self.invisibleChanges addObject:lastChange];
        [self.visibleChanges removeLastObject];
        return true;
    }
    
    return false;
}

- (BOOL)redoChange {
    if (self.invisibleChanges.count == 0) {
        return false;
    }
    
    id lastDiscardedChange = [self.invisibleChanges lastObject];
    if (lastDiscardedChange) {
        [self.visibleChanges addObject:lastDiscardedChange];
        [self.invisibleChanges removeLastObject];
        return true;
    }
    
    return false;
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

- (id)lastChange {
    return [self.visibleChanges lastObject];
}

- (id)lastInvisibleChange {
    return [self.invisibleChanges lastObject];
}

@end
