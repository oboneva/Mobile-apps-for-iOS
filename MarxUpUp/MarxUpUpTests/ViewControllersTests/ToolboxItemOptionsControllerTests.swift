//
//  ToolboxItemOptionsControllerTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 11.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class ToolboxItemOptionsControllerTests: XCTestCase {
    
    var toolbarItemOptionsController: ToolboxItemOptionsViewController!
    let delegate = FakeToolboxItemDelegate()

    override func setUp() {
        super.setUp()
        toolbarItemOptionsController = Storyboard.ToolboxItem.viewController(fromClass: ToolboxItemOptionsViewController.self)
    }

    override func tearDown() {
        toolbarItemOptionsController = nil
        super.tearDown()
    }
    
    func testDataSourceForArrows() {
        toolbarItemOptionsController.itemType = .Arrow
        _ = toolbarItemOptionsController.view
    
        XCTAssertTrue( toolbarItemOptionsController.itemOptionsCollectionView.dataSource?.isKind(of: ArrowsCollectionViewDataSource.self) ?? false)
    }
    
    func testDataSourceForShapes() {
        toolbarItemOptionsController.itemType = .Shape
        _ = toolbarItemOptionsController.view
        
        XCTAssertTrue( toolbarItemOptionsController.itemOptionsCollectionView.dataSource?.isKind(of: ShapesCollectionViewDataSource.self) ?? false)
    }
    
    func testDelegateMethodIsCalledOnDidSelectItem() {
        toolbarItemOptionsController.itemType = .Arrow
        toolbarItemOptionsController.toolboxItemDelegate = delegate
        _ = toolbarItemOptionsController.view
        
        toolbarItemOptionsController.collectionView(toolbarItemOptionsController.itemOptionsCollectionView, didSelectItemAt: IndexPath(item: 1, section: 1))
        XCTAssertTrue(delegate.didChooseOptionAtIndexIsCalled)
    }
    
    func testDidChooseOptionIsNotCalledWhenIndexIsOutOfBounds() {
        toolbarItemOptionsController.itemType = .Arrow
        toolbarItemOptionsController.toolboxItemDelegate = delegate
        _ = toolbarItemOptionsController.view
        
        delegate.didChooseOptionAtIndexIsCalled = false
        toolbarItemOptionsController.collectionView(toolbarItemOptionsController.itemOptionsCollectionView, didSelectItemAt: IndexPath(item: 10, section: 10))
        XCTAssertFalse(delegate.didChooseOptionAtIndexIsCalled)
    }

}


class FakeToolboxItemDelegate: ToolboxItemDelegate {
    var didChooseOptionAtIndexIsCalled = false
    var didChoosePenIsCalled = false
    var didChooseColorIsCalled = false
    var didChooseLineWidthIsCalled = false
    var didChooseTextAnnotationIsCalled = false
    
    func didChoose(_ option: Int, forToolboxItem type: ToolboxItemType) {
        didChooseOptionAtIndexIsCalled = true
    }
    
    func didChoosePen() {
        didChoosePenIsCalled = true
    }
    
    func didChooseColor(_ color: UIColor) {
        didChooseColorIsCalled = true
    }
    
    func didChoose(lineWidth width: Float) {
        didChooseLineWidthIsCalled = true
    }
    
    func didChoose(textAnnotationFromType type: ToolboxItemType) {
        didChooseTextAnnotationIsCalled = true
    }
}
