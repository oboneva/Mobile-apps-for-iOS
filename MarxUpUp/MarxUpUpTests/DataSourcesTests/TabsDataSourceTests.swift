//
//  TabsDataSourceTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 5.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class TabsDataSourceTests: XCTestCase {

    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    let dataSource = TabsCollectionViewDataSource()

    func testDefaultSelectedTabIsViral() {
        let result = dataSource.filter(atIndex: dataSource.defaultSelectedTabIndex.item)
        let expectedFilter = DataFilter(local: false, sort: .viral)
        XCTAssertEqual(result.isDataLocal, expectedFilter.isDataLocal)
        XCTAssertEqual(result.sort, expectedFilter.sort)
    }

    func testFilterWithIncorrectIndex() {
        let result = dataSource.filter(atIndex: 100)
        let expectedFilter = DataFilter(local: false, sort: .viral)
        XCTAssertEqual(result.isDataLocal, expectedFilter.isDataLocal)
        XCTAssertEqual(result.sort, expectedFilter.sort)
    }

    func testNumberOfSections() {
        XCTAssertEqual(dataSource.numberOfSections(in: collectionView), 1)
    }

    func testNumberOfTabsInTheSection() {
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), 4)
    }

}
