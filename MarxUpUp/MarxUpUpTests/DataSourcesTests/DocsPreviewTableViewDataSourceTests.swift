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
        
        guard let id = URL(string: "1"), let result = DBManager.pdfWithID(id) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(String.init(data: result.data, encoding: .ascii), "sdfgfdgh")
    }
}

class MockDatabaseManager: NSObject, LocalContentManaging {
    var images = [URL : LocalContentModel]()
    var docs = [URL : LocalContentModel]()

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
        return Array(docs.values)
    }
    
    func loadImages() -> [LocalContentModel] {
        return Array(images.values)
    }
    
    func pdfWithID(_ id: URL) -> LocalContentModel? {
        return docs.filter({ (k,v) -> Bool in
            k == id
        }).first?.value
    }
}

extension MockDatabaseManager: ContentSaving {
    func saveImageWithData(_ data: Data) {
        guard let id = URL(string: "\(images.count + 1)") else {
            return
        }
        let image = LocalContentModel(data, id)
        images[id] = image
    }
    
    func savePDFWithData(_ data: Data) {
        guard let id = URL(string: "\(docs.count + 1)") else {
            return
        }
        let doc = LocalContentModel(data, id)
        docs[id] = doc
    }
}

extension MockDatabaseManager: ContentUpdating {
    func updatePDF(_ id: URL, withData data: Data) {
        docs.updateValue(LocalContentModel(data, id), forKey: id)
    }
    
    func updateImage(_ id: URL, withData data: Data) {
        images.updateValue(LocalContentModel(data, id), forKey: id)
    }
}
