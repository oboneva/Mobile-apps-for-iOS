//
//  LocalPersistenceTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 6.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp
import CoreData
import UIKit

class LocalPersistenceTests: XCTestCase {

    var store: DatabaseManager!
    var imageData = "asdf".data(using: .ascii) ?? Data()
    var imageDataForUpdate = "qwer".data(using: .ascii) ?? Data()

    var documentData: Data {
        return "zxcv".data(using: .ascii) ?? Data()
    }

    var documentDataForUpdate: Data {
        return "tyui".data(using: .ascii) ?? Data()
    }

    lazy var managedObjectModel = {
       return NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
    }()

    lazy var fakePersistenceContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Model.xcdatamodeld", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = true

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            if let error = error {
                fatalError("Error: ")//+ error
            }
        })
        return container
    }()

    var saveNotificationCompletionHandler: ((Notification) -> Void)?

    func populate() {

        func insertImage(_ data: Data) -> Image? {
            let image = NSEntityDescription.insertNewObject(forEntityName: "Image",
                                                            into: fakePersistenceContainer.viewContext)
            image.setValue(data, forKey: "imageData")
            return image as? Image
        }

        func insertPDF(_ data: Data) -> PDF? {
            let pdf = NSEntityDescription.insertNewObject(forEntityName: "PDF",
                                                          into: fakePersistenceContainer.viewContext)
            pdf.setValue(data, forKey: "pdfData")
            return pdf as? PDF
        }

        _ = insertPDF(documentData)
        _ = insertImage(imageData)

        do {
            try fakePersistenceContainer.viewContext.save()
        } catch {
            print("Error: Creating fake data failed")
        }
    }

    func clearData() {
        let imagesRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(
            entityName: "Image")
        let pdfRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(
            entityName: "PDF")

        let images = try! fakePersistenceContainer.viewContext.fetch(imagesRequest) as! [NSManagedObject]
        let documents = try! fakePersistenceContainer.viewContext.fetch(pdfRequest) as! [NSManagedObject]

        for image in images {
            fakePersistenceContainer.viewContext.delete(image)
        }

        for pdf in documents {
            fakePersistenceContainer.viewContext.delete(pdf)
        }
    }

    override func setUp() {
        super.setUp()
        populate()
        store = DatabaseManager(withContainer: fakePersistenceContainer)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSaveContext(_:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    override func tearDown() {
        clearData()
        super.tearDown()
    }

    func waitForDidSaveNotification(completionHandler: @escaping ((Notification) -> Void)) {
        saveNotificationCompletionHandler = completionHandler
    }

    func didSaveContext(_ notification: Notification) {
        saveNotificationCompletionHandler?(notification)
    }

    func testSaveImage_SaveIsCalled() {
        let expect = expectation(description: "Save context is called")
        waitForDidSaveNotification { _ in expect.fulfill() }

        store.saveImageWithData(imageData)

        waitForExpectations(timeout: 2) { error -> Void in if error != nil { XCTFail() } }
    }

    func testSaveImage_DataIsSaved() {
        store.saveImageWithData(imageData)
        let images = store.loadImages()
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2

        images.forEach { (image) in
            if image.data == imageData {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 2) { error -> Void in if error != nil { XCTFail() } }
    }

    func testSavePDF_SaveIsCalled() {
        let expect = expectation(description: "Save context is called")
        waitForDidSaveNotification { _ in expect.fulfill() }

        store.savePDFWithData(documentData)

        waitForExpectations(timeout: 2) { error -> Void in if error != nil { XCTFail() } }
    }

    func testSavePDF_DataIsSaved() {
        store.savePDFWithData(documentData)
        let documents = store.loadPDFs()
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2

        documents.forEach { (doc) in
            if doc.data == documentData {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 2) { error -> Void in if error != nil { XCTFail() } }
    }

    func testUpdateImage() {
        var images = store.loadImages()
        guard let image = images.first else {
            XCTFail("Error: No images in the store")
            return
        }
        store.updateImage(image.id, withData: imageDataForUpdate)

        images = store.loadImages()
        guard let imageUpdated = images.first else {
            XCTFail("Error: Image with updated data was not saved")
            return
        }
        XCTAssertEqual(imageUpdated.data, imageDataForUpdate)
    }

    func testUpdatePDF() {
        var documents = store.loadPDFs()
        guard let doc = documents.first else {
            XCTFail("Error: No Documents in the store")
            return
        }
        store.updatePDF(doc.id, withData: documentDataForUpdate)

        documents = store.loadPDFs()
        guard let docUpdated = documents.first else {
            XCTFail("Error: Document with updated data was not saved")
            return
        }
        XCTAssertEqual(docUpdated.data, documentDataForUpdate)
    }
}
