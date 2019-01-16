//
//  DocsPreviewControllerTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 2.01.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import XCTest
import PDFKit
@testable import MarxUpUp

class DocsPreviewControllerTests: XCTestCase {
    
    let DBManager = MockDatabaseManager()
    
    var controller: DocsPreviewViewController!
    var dataSource: MockDocsPreviewTableViewDataSource!

    override func setUp() {
        super.setUp()
        controller = Storyboard.PreviewContent.viewController(fromClass: DocsPreviewViewController.self) as DocsPreviewViewController
        dataSource = MockDocsPreviewTableViewDataSource(withDatabaseManager: DBManager)
        controller?.setDependencies(dataSource)
        _ = controller.view
        
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }

    override func tearDown() {
        controller = nil
        dataSource = nil
        super.tearDown()
    }

    func testDocumentIsPresentedForAnnotationOnTap() {
        let index = IndexPath(row: 0, section: 0)
        controller.tableView(controller.PDFTableView, didSelectRowAt: index)
        guard let presented = controller.presentedViewController as? SingleDocumentViewController else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(presented.updateDatabaseDelegate != nil)
        XCTAssertEqual(dataSource.selectedModelIndexForUpdate ?? 100, index.row)
        XCTAssertEqual(presented.document?.dataRepresentation(), dataSource.doc?.dataRepresentation())
    }
    
    func testRowActions() {
        let actions = controller.tableView(controller.PDFTableView, editActionsForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(actions?.count, 1)
        
        let action = actions?.first
        
        XCTAssertEqual(action?.title, "Delete")
        XCTAssertEqual(action?.style, UITableViewRowAction.Style.destructive)
    }
}

class MockDocsPreviewTableViewDataSource: DocsPreviewTableViewDataSource {
    var doc = PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "test-document", ofType: "pdf") ?? ""))
    
    override func document(atIndex index: Int) -> PDFDocument? {
        return doc
    }
}
