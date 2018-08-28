//
//  ShipModel.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 21.08.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipModel : NSObject

@property (strong, nonatomic)NSString *name;
@property (assign)int size;
@property (strong, nonatomic)NSIndexPath *head;
@property (strong, nonatomic)NSIndexPath *tail;

+ (instancetype)newShipWithName:(NSString *)name andSize:(int)size;
+ (instancetype)newShipFromJSON:(NSDictionary *)dict;

- (BOOL)isCellAtIndexPathPartOfThisShip:(NSIndexPath *)indexPath;
- (BOOL)hasSunk;
- (void)hit;
- (NSDictionary *)toJSON;

@end
