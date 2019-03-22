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

    func testToolboxButton() {
        _ = controller.view
        XCTAssertTrue(controller.toolboxStackView?.isHidden ?? false)
        controller.onToolboxTap(UIButton())
        XCTAssertFalse(controller.toolboxStackView?.isHidden ?? true)
        controller.onToolboxTap(UIButton())
        XCTAssertTrue(controller.toolboxStackView?.isHidden ?? false)
    }

    func testSaveButton() {
        controller.document = testDoc
        controller.updateDatabaseDelegate = delegate
        _ = controller.view
        controller.onSaveTap(UIButton())

        XCTAssertTrue(delegate.updateDocIsCalled)
        XCTAssertTrue(controller.toolboxStackView?.isHidden ?? false)
    }

    func testOnTapToolboxIsHidden() {
        _ = controller.view
        controller.handleTapGestureWithRecogniser(UITapGestureRecognizer())

        XCTAssertTrue(controller.toolboxStackView?.isHidden ?? false)
    }

    func testsWillBeginDrawing() {
        controller.document = testDoc
        _ = controller.view
        controller.willBeginDrawing()

        XCTAssertTrue(controller.PDFDocumentView.documentView?.isUserInteractionEnabled ?? false)
        XCTAssertFalse(controller.PDFDocumentView.isUserInteractionEnabled)
    }
}
