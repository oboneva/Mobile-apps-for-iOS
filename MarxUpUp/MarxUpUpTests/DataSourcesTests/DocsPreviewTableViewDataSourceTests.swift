//
//  DocsPreviewTableViewDataSourceTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 13.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class DocsPreviewTableViewDataSourceTests: XCTestCase {

    let DBManager = MockDatabaseManager()
    var dataSource: DocsPreviewTableViewDataSource!
    var tableView = UITableView(frame: CGRect.zero)

    override func setUp() {
        super.setUp()
        dataSource = DocsPreviewTableViewDataSource(withDatabaseManager: DBManager)
        tableView.dataSource = dataSource
    }

    func testNumberOfSections() {
        XCTAssertEqual(1, dataSource.numberOfSections(in: tableView))
    }

    func testNumberOfItemsInSection() {
        XCTAssertEqual(3, dataSource.tableView(tableView, numberOfRowsInSection: 0))
    }

    func testUpdatePDF() {
        let newData = "sdfgfdgh".data(using: .ascii) ?? Data()
        dataSource.selectedModelIndexForUpdate = 1
        dataSource.updatePDF(withData: newData)

        guard let id = URL(string: "2") else {
            XCTFail("Creation of URL from string failed")
            return
        }

        XCTAssertTrue(DBManager.updatePDFIsCalled)
        XCTAssertEqual(DBManager.updateWithPDF?.data, newData)
        XCTAssertEqual(DBManager.updateWithPDF?.id, id)
    }
}

class MockDatabaseManager: NSObject, LocalContentManaging {
    var images = [LocalContentModel]()
    var docs = [LocalContentModel]()

    var updatePDFIsCalled = false
    var updateImageISCalled = false

    var updateWithPDF: LocalContentModel?
    var updateWithImage: LocalContentModel?

    override init() {
        super.init()
        addFakeData()
    }

    func addFakeData() {
        saveImageWithData("image1".data(using: .ascii) ?? Data())
        saveImageWithData("image2".data(using: .ascii) ?? Data())
        saveImageWithData("image3".data(using: .ascii) ?? Data())

        savePDFWithData("pdf1".data(using: .ascii) ?? Data())
        savePDFWithData("pdf2".data(using: .ascii) ?? Data())
        savePDFWithData("pdf3".data(using: .ascii) ?? Data())
    }
}

extension MockDatabaseManager: ContentLoading {
    func loadPDFs() -> [LocalContentModel] {
        return docs
    }

    func loadImages() -> [LocalContentModel] {
        return images
    }

    func pdfWithID(_ id: URL) -> LocalContentModel? {
        return docs.filter({ (doc) -> Bool in
            doc.id == id
        }).first
    }
}

extension MockDatabaseManager: ContentSaving {
    func saveImageWithData(_ data: Data) {
        guard let id = URL(string: "\(images.count + 1)") else {
            return
        }
        images.append(LocalContentModel(data, id))
    }

    func savePDFWithData(_ data: Data) {
        guard let id = URL(string: "\(docs.count + 1)") else {
            return
        }
        docs.append(LocalContentModel(data, id))
    }
}

extension MockDatabaseManager: ContentUpdating {
    func updatePDF(_ id: URL, withData data: Data) {
        for doc in docs where doc.id == id {
            doc.data = data
        }
        updateWithPDF = LocalContentModel(data, id)
        updatePDFIsCalled = true
    }

    func updateImage(_ id: URL, withData data: Data) {
        for image in images where image.id == id {
            image.data = data
        }
        updateWithImage = LocalContentModel(data, id)
        updateImageISCalled = true
    }
}

extension MockDatabaseManager: ContentDeleting {
    func deletePDF(_ id: URL) {
        images = images.filter { $0.id != id }
    }

    func deleteImage(_ id: URL) {
        docs = docs.filter { $0.id != id }
    }
}
