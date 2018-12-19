//
//  ToolboxItemOptionsViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ToolboxItemOptionsViewController: UIViewController {

    @IBOutlet weak var itemOptionsCollectionView: UICollectionView!
    var itemType : ToolboxItemType = ToolboxItemType.Shape
    private var dataSource : ToolboxItemCollectionDataSource?
    weak var toolboxItemDelegate : ToolboxItemDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = itemType.dataSource()
        itemOptionsCollectionView.dataSource = dataSource
        itemOptionsCollectionView.delegate = self
        itemOptionsCollectionView.backgroundColor = UIColor.clear
    }
}

extension ToolboxItemOptionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard toolboxItemDelegate != nil else {
            print("Error: ToolboxItemDelegate is nil")
            return
        }
        
        guard let option = dataSource?.option(atIndex: indexPath.item) else {
            print("Error: No data source")
            return
        }
        
        toolboxItemDelegate?.didChoose(option, forToolboxItem: itemType)
    }
}
