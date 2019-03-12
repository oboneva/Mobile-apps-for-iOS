//
//  ShapesDataSourceTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 5.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit
import XCTest
@testable import MarxUpUp

class ShapesDataSourceTests: XCTestCase {

    var dataSource = ShapesCollectionViewDataSource()
    let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    func testNumberOfSections() {
        XCTAssertEqual(dataSource.numberOfSections(in: collectionView), 1)
    }

    func testNumberOfItemsInSection() {
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), 3)
    }

    func testOptionAtIndex() {
        XCTAssertEqual(dataSource.option(atIndex: 0), ShapeType.circle.rawValue)
        XCTAssertEqual(dataSource.option(atIndex: 1), ShapeType.roundedRectangle.rawValue)
        XCTAssertEqual(dataSource.option(atIndex: 2), ShapeType.regularRectangle.rawValue)
    }
}
