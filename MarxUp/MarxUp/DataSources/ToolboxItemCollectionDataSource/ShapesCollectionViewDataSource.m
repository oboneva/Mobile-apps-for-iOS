//
//  ShapesCollectionViewDataSource.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 26.09.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "ShapesCollectionViewDataSource.h"
#import "ToolboxItemOptionsCollectionViewCell.h"
#import "ShapeModel.h"

@interface ShapesCollectionViewDataSource ()

@property (strong, nonatomic) NSArray<ShapeModel *> *shapes;

@end

@implementation ShapesCollectionViewDataSource

+ (instancetype)newDataSource {
    ShapesCollectionViewDataSource *newSource = [ShapesCollectionViewDataSource new];
    if (newSource) {
        ShapeModel *circle = [ShapeModel newShapeFromType:ShapeTypeCircle];
        ShapeModel *triangle = [ShapeModel newShapeFromType:ShapeTypeTriangle];
        ShapeModel *rectangle = [ShapeModel newShapeFromType:ShapeTypeRegularRectangle];
        ShapeModel *roundedRect  =[ShapeModel newShapeFromType:ShapeTypeRoundedRectangle];
        newSource.shapes = @[roundedRect, circle, triangle, rectangle];
    }
    
    return newSource;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shapes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ToolboxItemOptionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_TOOLBOX_ITEM_OPTIONS_CELL forIndexPath:indexPath];
    ShapeModel *model = self.shapes[indexPath.item];
    
    cell.imageView.image = model.image;
    
    return cell;
}

- (ShapeType)optionAtIndex:(NSInteger)index {
    return self.shapes[index].type;
}


@end
