//
//  ToolboxDataSourceTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 5.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class ToolboxDataSourceTests: XCTestCase {

    func testCountOfToolboxItemsForAnnotatingPDF() {
        let dataSource = ToolboxDataSource.init(forItemsFromType: .pdf)
        XCTAssertEqual(dataSource.itemsCount, 10)
    }

    func testCountOfToolboxItemsForAnnotatingImages() {
        let dataSource = ToolboxDataSource.init(forItemsFromType: .image)
        XCTAssertEqual(dataSource.itemsCount, 7)
    }

    func testLastItemsAreUndoRedo() {
        var dataSource = ToolboxDataSource(forItemsFromType: .image)
        XCTAssertEqual(dataSource.type(atIndex: 6), ToolboxItemType.redo)
        XCTAssertEqual(dataSource.type(atIndex: 5), ToolboxItemType.undo)

        dataSource = ToolboxDataSource(forItemsFromType: .pdf)
        XCTAssertEqual(dataSource.type(atIndex: 9), ToolboxItemType.redo)
        XCTAssertEqual(dataSource.type(atIndex: 8), ToolboxItemType.undo)
    }

    func testToolboxWithItemsForAnnotatingPDFContainsTextRelatedItems() {
        let dataSource = ToolboxDataSource(forItemsFromType: .pdf)
        let items = Array(1..<dataSource.itemsCount).map({ dataSource.type(atIndex: $0) })

        XCTAssert(items.contains(.textHighlight))
        XCTAssert(items.contains(.textUnderline))
        XCTAssert(items.contains(.textStrikeThrough))
    }
}
