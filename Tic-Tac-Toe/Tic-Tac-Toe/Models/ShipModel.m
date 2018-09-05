//
//  ShipModel.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 21.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <UIKit/UITableView.h>
#import "ShipModel.h"
#import "Utilities.h"

@interface ShipModel ()
@property (assign)int hitCount;

@end


@implementation ShipModel

+ (instancetype)newShipWithName:(NSString *)name andSize:(int)size {
    ShipModel *newShip = [[ShipModel alloc] init];
    if (newShip) {
        newShip.size = size;
        newShip.name = name;
        newShip.hitCount = 0;
        newShip.color = [Utilities colorForShipWithName:name];
    }
    return newShip;
}

- (void)hit {
    self.hitCount++;
}

- (BOOL)hasSunk {
    return self.hitCount == self.size;
}

- (BOOL)isCellAtIndexPathPartOfThisShip:(NSIndexPath *)indexPath {
    return (indexPath.section == self.head.section && indexPath.item >= self.head.item && indexPath.item <= self.tail.item) ||
    (indexPath.item == self.head.item && indexPath.section >= self.head.section && indexPath.section <= self.tail.section);
}

- (NSDictionary *)toJSON {
    return @{@"name" : self.name,
             @"size" : [NSNumber numberWithInt:self.size],
             @"head" : [self indexPathToJSON:self.head],
             @"tail" : [self indexPathToJSON:self.tail]};
}

- (NSDictionary<NSString *, NSNumber *> *)indexPathToJSON:(NSIndexPath *)indexPath {
    NSNumber *section = [NSNumber numberWithInteger:indexPath.section];
    NSNumber *item = [NSNumber numberWithInteger:indexPath.item];
    return @{@"section" : section, @"item" : item};
}

- (NSIndexPath *)indexPathFromJSON:(NSDictionary<NSString *, NSNumber *> *)dict {
    return [NSIndexPath indexPathForItem:[dict[@"item"] integerValue] inSection:[dict[@"section"] integerValue]];
}

+ (instancetype)newShipFromJSON:(NSDictionary *)dict {
    ShipModel *newShip = [[ShipModel alloc] init];
    if (newShip) {
        newShip.name = dict[@"name"];
        newShip.size = [dict[@"size"] intValue];
        newShip.hitCount = 0;
        newShip.head = [newShip indexPathFromJSON:dict[@"head"]];
        newShip.tail = [newShip indexPathFromJSON:dict[@"tail"]];
        newShip.color = [Utilities colorForShipWithName:newShip.name];
    }
    return newShip;
}

@end

