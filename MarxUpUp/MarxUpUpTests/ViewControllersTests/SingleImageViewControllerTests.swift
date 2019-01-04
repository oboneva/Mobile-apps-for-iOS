//
//  SingleImageViewControllerTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 20.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class SingleImageViewControllerTests: XCTestCase {
    
    var controller: SingleImageViewController!
    let delegate = FakeUpdateDatabaseDelegate()
    let testImage = UIImage(named: "test-image")

    override func setUp() {
        super.setUp()
        controller = Storyboard.Annotate.viewController(fromClass: SingleImageViewController.self)
        controller.updateDatabaseDelegate = delegate
    }

    override func tearDown() {
        controller = nil
        super.tearDown()
    }

    func testAnnotateButton() {
        _ = controller.view
        XCTAssertFalse(controller.annotatedImageView.isUserInteractionEnabled)
        
        controller.didSelectAnnotate()
        XCTAssertTrue(controller.annotatedImageView.isUserInteractionEnabled)
    }
    
    func testToolboxButton() {
        _ = controller.view
        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
        controller.didSelectToolbox()
        XCTAssertFalse(controller.toolboxView?.isHidden ?? true)
        controller.didSelectToolbox()
        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
    }
    
    func testResetButton() {
        controller.image = testImage ?? UIImage()
        _ = controller.view
        
        controller.annotatedImageView.image = nil
        controller.didSelectReset()
        XCTAssertEqual(controller.annotatedImageView.image, testImage)
    }

    func testSaveButton() {
        controller.image = testImage ?? UIImage()
        _ = controller.view
        controller.didSelectSave()
        
        XCTAssertTrue(delegate.updateImageIsCalled)
        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
    }
    
    func testOnTapToolboxIsHidden() {
        _ = controller.view
        controller.handleTapWithGestureRecognizer(UITapGestureRecognizer())
        
        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
    }
}

class FakeUpdateDatabaseDelegate: UpdateDatabaseDelegate {
    
    var updateImageIsCalled = false
    var updateDocIsCalled = false
    
    func updateImage(withData data: Data) {
        updateImageIsCalled = true
    }
    
    func updatePDF(withData data: Data) {
        updateDocIsCalled = true
    }
}
