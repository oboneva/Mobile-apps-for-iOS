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

    func testAnnotateButton() {
        XCTAssertFalse(controller.annotatedImageView.isUserInteractionEnabled)

        controller.didSelectAnnotate()
        XCTAssertTrue(controller.annotatedImageView.isUserInteractionEnabled)
    }

    func testToolboxButton() {
        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
        controller.didSelectToolbox()
        XCTAssertFalse(controller.toolboxView?.isHidden ?? true)
        controller.didSelectToolbox()
        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
    }

    func testResetButton() {
        controller.didSelectReset()
        XCTAssertTrue(annotator.resetIsCalled)
    }

    func testSaveButton() {
        controller.didSelectSave()

        XCTAssertTrue(delegate.updateImageIsCalled)
        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
    }

    func testNavigationGoBackWithoutUnsavedWork() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()

        annotator.unsavedWork = false

        controller.didSelectGoBack()

        let presentedController = controller.presentedViewController
        XCTAssertNil(presentedController)
    }

    func testNavigationGoBackWithUnsavedWork() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()

        annotator.unsavedWork = true
        controller.didSelectGoBack()

        guard _ = controller.presentedViewController as? UIAlertController else {
            XCTFail()
            return
        }
    }

    func testOnTapToolboxIsHidden() {
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

class MockAnnotator: Annotating {

    var resetIsCalled = false

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
}
