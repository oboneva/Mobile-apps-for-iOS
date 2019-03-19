//
//  StyleItemsModifierTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 18.03.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class StyleItemsModifierTests: XCTestCase {

    func testAddingNewItemOverlappingEndOfAnotherOne() {
        let oldStyleItem = StyleItem(.strokeColor, UIColor.black, NSRange(location: 5, length: 3))
        let newStyleItem = StyleItem(.strokeColor, UIColor.blue, NSRange(location: 7, length: 2))

        let items = StyleItemsModifier.styleItemsAppending(newStyleItem, to: [oldStyleItem])
        let expectedModifyedItem = StyleItem(.strokeColor, UIColor.black, NSRange(location: 5, length: 2))
        let expectedItems = [expectedModifyedItem, newStyleItem]

        XCTAssertEqual(items, expectedItems)
    }

    func testAddingNewItemOverlappingLocationOfAnotherOne() {
        let oldStyleItem = StyleItem(.strokeColor, UIColor.black, NSRange(location: 5, length: 3))
        let newStyleItem = StyleItem(.strokeColor, UIColor.blue, NSRange(location: 3, length: 3))

        let items = StyleItemsModifier.styleItemsAppending(newStyleItem, to: [oldStyleItem])
        let expectedModifyedItem = StyleItem(.strokeColor, UIColor.black, NSRange(location: 6, length: 2))
        let expectedItems = [expectedModifyedItem, newStyleItem]

        XCTAssertEqual(items, expectedItems)
    }

    func testAddingNewItemEntirelyOverlappingAnotherOne() {
        let oldStyleItem = StyleItem(.strokeColor, UIColor.black, NSRange(location: 5, length: 3))
        let newStyleItem = StyleItem(.strokeColor, UIColor.blue, NSRange(location: 3, length: 6))

        let items = StyleItemsModifier.styleItemsAppending(newStyleItem, to: [oldStyleItem])
        let expectedItems = [newStyleItem]

        XCTAssertEqual(items, expectedItems)
    }

    func testAddingNewItemAboveAnotherOne() {
        let oldStyleItem = StyleItem(.strokeColor, UIColor.black, NSRange(location: 3, length: 7))
        let newStyleItem = StyleItem(.strokeColor, UIColor.blue, NSRange(location: 5, length: 3))

        let items = StyleItemsModifier.styleItemsAppending(newStyleItem, to: [oldStyleItem])
        let newItemWithErasedEnd = StyleItem(.strokeColor, UIColor.black, NSRange(location: 3, length: 2))
        let newItemWithErasedLocation = StyleItem(.strokeColor, UIColor.black, NSRange(location: 8, length: 2))
        let expectedItems = [newItemWithErasedEnd, newItemWithErasedLocation, newStyleItem]

        XCTAssertEqual(items, expectedItems)
    }

    func testAppendThreeSameStyles() {
        let styleItem1 = StyleItem(.strokeColor, UIColor.blue, NSRange(location: 1, end: 3))
        let styleItem2 = StyleItem(.strokeColor, UIColor.blue, NSRange(location: 5, end: 10))

        let newStyleItem = StyleItem(.strokeColor, UIColor.blue, NSRange(location: 3, end: 5))

        let items = StyleItemsModifier.styleItemsAppending(newStyleItem, to: [styleItem1, styleItem2])
        let expectedItems = [StyleItem(.strokeColor, UIColor.blue, NSRange(location: 1, end: 10))]

        XCTAssertEqual(expectedItems, items)
    }

    func testAppendTwoSameStyles() {
        let styleItem = StyleItem(.strokeColor, UIColor.blue, NSRange(location: 1, end: 3))
        let newStyleItem = StyleItem(.strokeColor, UIColor.blue, NSRange(location: 3, end: 5))

        let items = StyleItemsModifier.styleItemsAppending(newStyleItem, to: [styleItem])
        let expectedItems = [StyleItem(.strokeColor, UIColor.blue, NSRange(location: 1, end: 5))]

        XCTAssertEqual(expectedItems, items)
    }

}
