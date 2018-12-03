//
//  ShapesCollectionViewDataSource.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 14.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

final class ShapesCollectionViewDataSource: NSObject {
    private let shapes = [ShapeModel(withShapeType: ShapeType.Circle), ShapeModel(withShapeType: ShapeType.RoundedRectangle), ShapeModel(withShapeType: ShapeType.RegularRectangle)]
}

extension ShapesCollectionViewDataSource : ToolboxItemCollectionDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shapes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(fromClass: ToolboxItemOptionsCollectionViewCell.self, forIndexPath: indexPath)
        
        cell.itemImageView.image = shapes[indexPath.item].image
        
        return cell
    }
    
    func option(atIndex index: Int) -> Int {
        return shapes[index].type.rawValue
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
