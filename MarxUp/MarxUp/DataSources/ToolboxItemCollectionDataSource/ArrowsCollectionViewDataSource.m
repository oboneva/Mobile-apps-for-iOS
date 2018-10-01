//
//  ArrowsCollectionViewDataSource.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 1.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ArrowsCollectionViewDataSource.h"
#import "ArrowModel.h"


@interface ArrowsCollectionViewDataSource ()

@property (strong, nonatomic)NSArray<ArrowModel *> *arrows;

@end

@implementation ArrowsCollectionViewDataSource

/*
+ (instancetype)newDataSource {
    
}
*/
- (ArrowEndLineType)optionAtIndex:(NSInteger)index {
    return self.arrows[index].type;
}

@end
