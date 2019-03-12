//
//  CellTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 5.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class CellTests: XCTestCase {

    func testDeqingTableviewCells() {
        let pdfTable = UITableView(frame: CGRect.zero)
        pdfTable.register(PDFTableViewCell.self, forCellReuseIdentifier: "PDFTableViewCellID")

        let cell = pdfTable.dequeueReusableCell(fromClass: PDFTableViewCell.self, forIndexPath: IndexPath())

        XCTAssert(cell.isMember(of: PDFTableViewCell.self))
    }

    func testDequeuingCollecitonViewCells() {
        let tabsCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        tabsCollection.register(TabsCollectionViewCell.self, forCellWithReuseIdentifier: "TabsCollectionViewCellID")

        let cell = tabsCollection.dequeueReusableCell(fromClass: TabsCollectionViewCell.self, forIndexPath: IndexPath())

        XCTAssert(cell.isMember(of: TabsCollectionViewCell.self))
    }

}
