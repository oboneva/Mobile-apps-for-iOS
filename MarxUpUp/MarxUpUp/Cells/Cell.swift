//
//  Cell.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 8.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import Foundation
import UIKit


extension UITableViewCell {
    class var identifier: String {
        return "\(self)" + "ID"
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(fromClass cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.identifier, for: indexPath) as? T else {
            print("Cell from class" + "\(cellClass)" + "cannot be dequeued")
            return UITableViewCell() as! T
        }

        return cell
    }
}

extension UICollectionViewCell {
    class var identifier: String {
        return "\(self)" + "ID"
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(fromClass cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellClass.identifier, for: indexPath) as? T else {
            print("Cell from class" + "\(cellClass)" + "cannot be dequeued")
            return UICollectionViewCell() as! T
        }

        return cell
    }
}
