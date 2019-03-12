//
//  SingleDocViewControllerTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 20.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp
import PDFKit

class SingleDocViewControllerTests: XCTestCase {

    var controller: SingleDocumentViewController!
    let delegate = FakeUpdateDatabaseDelegate()
    let annotator = MockAnnotator()
    let testDoc = PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "test-document",
                                                                         ofType: "pdf") ?? ""))

    override func setUp() {
        super.setUp()
        controller = Storyboard.annotate.viewController(fromClass: SingleDocumentViewController.self)
        controller.setDependancies(annotator)
    }

    override func tearDown() {
        controller = nil
        super.tearDown()
    }

    func testAnnotateButtton() {
        controller.document = testDoc
        _ = controller.view
        controller.viewDidAppear(false)

        XCTAssertFalse(controller.PDFDocumentView.documentView?.isUserInteractionEnabled ?? true)

        controller.didSelectAnnotate()
        XCTAssertTrue(controller.PDFDocumentView.documentView?.isUserInteractionEnabled ?? false)
        XCTAssertFalse(controller.PDFDocumentView.isUserInteractionEnabled)
    }

    func testToolboxButton() {
        _ = controller.view
        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
        controller.didSelectToolbox()
        XCTAssertFalse(controller.toolboxView?.isHidden ?? true)
        controller.didSelectToolbox()
        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
    }

    func testSaveButton() {
        controller.document = testDoc
        controller.updateDatabaseDelegate = delegate
        _ = controller.view
        controller.didSelectSave()

        XCTAssertTrue(delegate.updateDocIsCalled)
        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
    }

    func testOnTapToolboxIsHidden() {
        _ = controller.view
        controller.handleTapGestureWithRecogniser(UITapGestureRecognizer())

        XCTAssertTrue(controller.toolboxView?.isHidden ?? false)
    }

    func testsWillBeginDrawing() {
        controller.document = testDoc
        _ = controller.view
        controller.willBeginDrawing()

        XCTAssertTrue(controller.PDFDocumentView.documentView?.isUserInteractionEnabled ?? false)
        XCTAssertFalse(controller.PDFDocumentView.isUserInteractionEnabled)
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

}
