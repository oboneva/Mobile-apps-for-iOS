//
//  ChangesManagerTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 5.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
import PDFKit
@testable import MarxUpUp

class ChangesManagerTests: XCTestCase {

    var changes: ChangesManager!

    override func setUp() {
        super.setUp()
        changes = ChangesManager()
    }

    override func tearDown() {
        changes = nil
        super.tearDown()
    }

    func testCannotUndoWithoutChanges() {
        changes.undo { XCTFail("Successful undo, but without changes ot be undone.") }
    }

    func testCannotRedoWithoutChanges() {
        changes.redo { XCTFail("Successful redo, but without changes ot be redone.") }
    }

    func testCannotRedoAfterReset() {
        changes.reset()
        changes.redo { XCTFail("Successful redo, but after reset.") }
    }

    func testCanUndoChange() {
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 3

        changes.addTextAnnotation([PDFAnnotation](), forPage: PDFPage())
        changes.undo { expectation.fulfill() }

        changes.addInkPDFAnnotation(PDFAnnotation(), forPage: PDFPage())
        changes.undo { expectation.fulfill() }

        changes.addInkImageAnnotation(withLines: UIBezierPath(), forImage: UIImage(), andFill: false)
        changes.undo { expectation.fulfill() }

        waitForExpectations(timeout: 1) { error -> Void in if error != nil { XCTFail() } }
    }

    func testCanRedoChange() {
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 2

        changes.addTextAnnotation([PDFAnnotation](), forPage: PDFPage())
        changes.undo { expectation.fulfill() }
        changes.redo { expectation.fulfill() }

        waitForExpectations(timeout: 1) { error -> Void in if error != nil { XCTFail() } }
    }

    func testPDFInkAnnotationExecute() {
        let annotation = PDFAnnotation()
        let page = PDFPage()
        let inkAnnotation = PDFInkAnnotation.init(annotation, forPDFPage: page)
        inkAnnotation.execute()

        XCTAssert(page.annotations.count == 1)
        XCTAssert(page.annotations.contains(annotation))
    }

    func testPDFInkAnnotationUnexecute() {
        let annotation = PDFAnnotation()
        let page = PDFPage()
        let inkAnnotation = PDFInkAnnotation.init(annotation, forPDFPage: page)
        page.addAnnotation(annotation)

        inkAnnotation.unexecute()
        XCTAssert(page.annotations.isEmpty)
    }

}
