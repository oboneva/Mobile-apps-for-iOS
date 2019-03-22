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
    let annotator = MockAnnotator()
    let testImage = UIImage(named: "test-image")

    override func setUp() {
        super.setUp()
        controller = Storyboard.annotate.viewController(fromClass: SingleImageViewController.self)
        controller.setDependancies(annotator)
        controller.updateDatabaseDelegate = delegate
        controller.image = testImage ?? UIImage()
        _ = controller.view
    }

    override func tearDown() {
        controller = nil
        super.tearDown()
    }

    func testToolboxButton() {
        XCTAssertTrue(controller.toolboxStackView?.isHidden ?? false)
        controller.onToolboxTap(UIButton())
        XCTAssertFalse(controller.toolboxStackView?.isHidden ?? true)
        controller.onToolboxTap(UIButton())
        XCTAssertTrue(controller.toolboxStackView?.isHidden ?? false)
    }

    func testResetButton() {
        controller.onResetTap(UIButton())
        XCTAssertTrue(annotator.resetIsCalled)
    }

    func testSaveButton() {
        controller.onSaveTap(UIButton())

        XCTAssertTrue(delegate.updateImageIsCalled)
        XCTAssertTrue(controller.toolboxStackView?.isHidden ?? false)
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

class MockAnnotator: Annotating, EditedContentStateDelegate, ToolboxItemDelegate {
    var resetIsCalled = false
    var saveIsCalled = false

    var undoIsCalled = false
    var redoIsCalled = false

    var didChoosePenIsCalled = false

    var unsavedWork = false
    var isThereUnsavedWork: Bool {
        return unsavedWork
    }

    func beginAnnotating(atPoint point: CGPoint) {}
    func continueAnnotating(atPoint point: CGPoint) {}
    func endAnnotating(atPoint point: CGPoint) {}

    func reset() {
        resetIsCalled = true
    }

    func save() {
        saveIsCalled = true
    }

    func didSelectUndo() {
        undoIsCalled = true
    }

    func didSelectRedo() {
        redoIsCalled = true
    }

    func didChoose(textAnnotationFromType type: ToolboxItemType) {}

    func didChoosePen() {
        didChoosePenIsCalled = true
    }

    func didChoose(_ option: Int, forToolboxItem type: ToolboxItemType) {}

    func didChoose(lineWidth width: Float) {}

    func didChooseColor(_ color: UIColor) {}
}
