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
        let dataSource = ToolboxDataSource.init(forItemsFromType: .PDF)
        XCTAssertEqual(dataSource.itemsCount, 10)
    }
    
    func testCountOfToolboxItemsForAnnotatingImages() {
        let dataSource = ToolboxDataSource.init(forItemsFromType: .Image)
        XCTAssertEqual(dataSource.itemsCount, 7)
    }
    
    func testLastItemsAreUndoRedo() {
        var dataSource = ToolboxDataSource(forItemsFromType: .Image)
        XCTAssertEqual(dataSource.type(atIndex: 6), ToolboxItemType.Redo)
        XCTAssertEqual(dataSource.type(atIndex: 5), ToolboxItemType.Undo)
        
        dataSource = ToolboxDataSource(forItemsFromType: .PDF)
        XCTAssertEqual(dataSource.type(atIndex: 9), ToolboxItemType.Redo)
        XCTAssertEqual(dataSource.type(atIndex: 8), ToolboxItemType.Undo)
    }
    
    func testToolboxWithItemsForAnnotatingPDFContainsTextRelatedItems() {
        let dataSource = ToolboxDataSource(forItemsFromType: .PDF)
        let items = Array(1..<dataSource.itemsCount).map({ dataSource.type(atIndex: $0) })
        
        XCTAssert(items.contains(.TextHighlight))
        XCTAssert(items.contains(.TextUnderline))
        XCTAssert(items.contains(.TextStrikeThrough))
    }
}
