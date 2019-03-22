//
//  DatabaseManager.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 27.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager: NSObject, LocalContentManaging {
    private var context: NSManagedObjectContext

    init(withContainer container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        context = container.viewContext
    }

    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Error: Saving changes failed")
        }
    }

    private func objectWithID(_ id: URL) -> NSManagedObject? {
        guard let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: id) else {
            print("Error: Creation of ID from URL failed")
            return nil
        }
        return context.object(with: objectID)
    }
}

extension DatabaseManager: ContentUpdating {
    func updatePDF(_ id: URL, withData data: Data) {
        let pdf = objectWithID(id) as? PDF
        pdf?.pdfData = data

        saveChanges()
    }

    func updateImage(_ id: URL, withData data: Data) {
        let image = objectWithID(id) as? Image
        image?.imageData = data

        saveChanges()
    }
}

extension DatabaseManager: ContentSaving {
    func savePDFWithData(_ data: Data) {
        let pdf = PDF(context: context)
        pdf.pdfData = data
        saveChanges()
    }

    func saveImageWithData(_ data: Data) {
        let image = Image(context: context)
        image.imageData = data
        saveChanges()
    }
}

extension DatabaseManager: ContentLoading {
    func loadImages() -> [LocalContentModel] {
        do {
            guard let images = try context.fetch(Image.fetchRequest()) as? [Image] else {
                return [LocalContentModel]()
            }

            return images.map { (image) -> LocalContentModel in
                LocalContentModel(image.imageData ?? Data(), image.objectID.uriRepresentation())
            }
        } catch {
            print("Error: Fetching images failed")
        }
        return [LocalContentModel]()
    }

    func loadPDFs() -> [LocalContentModel] {
        do {
            guard let docs = try context.fetch(PDF.fetchRequest()) as? [PDF] else {
                return [LocalContentModel]()
            }

            if docs.isEmpty {
                FileManager.getDataFromDefaultDocuments().forEach { savePDFWithData($0) }
                return loadPDFs()
            }
            return docs.map { (doc) -> LocalContentModel in
                LocalContentModel(doc.pdfData ?? Data(), doc.objectID.uriRepresentation())
            }
        } catch {
            print("Error: Fetching documents failed")
        }
        return [LocalContentModel]()
    }
}

extension DatabaseManager: ContentDeleting {
    func deleteImage(_ id: URL) {
        guard let image = objectWithID(id) as? Image else {
            return
        }

        context.delete(image)
        saveChanges()
    }

    func deletePDF(_ id: URL) {
        guard let pdf = objectWithID(id) as? PDF else {
            return
        }

        context.delete(pdf)
        saveChanges()
    }
}
