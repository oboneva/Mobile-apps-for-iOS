//
//  ToolbarTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 6.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class ToolbarTests: XCTestCase {

    var toolbarController: ToolbarViewController!
    let delegate = FakeToolbarButtonsTarget()

    override func setUp() {
        super.setUp()
        toolbarController = Storyboard.Toolbar.initialViewController() as? ToolbarViewController
        _ = toolbarController.view
        toolbarController.toolbarButtonsDelegate = delegate
    }

    override func tearDown() {
        toolbarController = nil
        super.tearDown()
    }

    func testAnnotationButtonsAreHiddenAfterLoad() {
        XCTAssert(toolbarController.saveButton.isHidden == true)
        XCTAssert(toolbarController.resetButton.isHidden == true)
        XCTAssert(toolbarController.toolboxButton.isHidden == true)
    }

    func testSaveIsCalled() {
        toolbarController.onSaveTap(self)
        XCTAssertTrue(delegate.saveIsCalled)
    }

    func testResetIsCalled() {
        toolbarController.onResetTap(self)
        XCTAssertTrue(delegate.resetIsCalled)
    }

    func testToolboxIsCalled() {
        toolbarController.onToolboxTap(self)
        XCTAssertTrue(delegate.toolboxIsCalled)
    }

    func testAnnotateIsCalled() {
        toolbarController.onAnnotateTap(self)
        XCTAssertTrue(delegate.annotateIsCalled)
    }

    func testGoBackIsCalled() {
        toolbarController.onBackTap(self)
        XCTAssertTrue(delegate.goBackIsCalled)
    }

}

class FakeToolbarButtonsTarget: ToolbarButtonsDelegate {

    var saveIsCalled = false
    var resetIsCalled = false
    var toolboxIsCalled = false
    var annotateIsCalled = false
    var goBackIsCalled = false

    func didSelectSave() {
        saveIsCalled = true
    }

    func didSelectReset() {
        resetIsCalled = true
    }

    func didSelectToolbox() {
        toolboxIsCalled = true
    }

    func didSelectAnnotate() {
        annotateIsCalled = true
    }

    func didSelectGoBack() {
        goBackIsCalled = true
    }
}
