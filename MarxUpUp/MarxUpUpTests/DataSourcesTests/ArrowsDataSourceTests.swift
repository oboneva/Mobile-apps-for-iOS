//
//  ArrowsDataSourceTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 5.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class ArrowsDataSourceTests: XCTestCase {

    var dataSource: ArrowsCollectionViewDataSource!
    let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func setUp() {
        super.setUp()
        dataSource = ArrowsCollectionViewDataSource()
        collectionView.dataSource = dataSource
    }

    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }

    func testNumberOfSections() {
        XCTAssertEqual(dataSource.numberOfSections(in: collectionView), 1)
    }

    func testNumberOfItemsInTheSection() {
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), 2)
    }

    func testOptionAtIndex() {
        XCTAssertEqual(ArrowEndLineType.open.rawValue, dataSource.option(atIndex: 0))
        XCTAssertEqual(ArrowEndLineType.closed.rawValue, dataSource.option(atIndex: 1))
    }

    func testOptionAtIndexOutOfBounds() {
        XCTAssertEqual(-1, dataSource.option(atIndex: -5))
        XCTAssertEqual(-1, dataSource.option(atIndex: 10))
    }

}
