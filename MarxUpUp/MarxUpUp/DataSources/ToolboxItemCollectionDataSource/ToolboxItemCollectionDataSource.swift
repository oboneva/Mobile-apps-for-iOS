//
//  ToolboxItemCollectionDataSource.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

protocol ToolboxItemCollectionDataSource: UICollectionViewDataSource {
    func option(atIndex: Int) -> Int

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell

    func numberOfSections(in collectionView: UICollectionView) -> Int
}
