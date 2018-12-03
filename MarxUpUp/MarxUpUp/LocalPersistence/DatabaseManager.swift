//
//  DatabaseManager.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 27.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class DatabaseManager: NSObject {
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func save(pdfWithData data: Data) {
        let pdf = PDF(context: context)
        pdf.pdfData = data
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func save(imageWithData data: Data) {
        let image = Image(context: context)
        image.imageData = data
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func updatePDF(_ pdf: PDF, withData data: Data) {
        pdf.pdfData = data
        saveChanges()
    }
    
    func updateImage(_ image: Image, withData data: Data) {
        image.imageData = data
        saveChanges()
    }
    
    private func saveChanges() {
        do {
            try context.save()
        }
        catch {
            print("Error: Saving changes failed")
        }
    }
    
    func loadImages() -> [Image] {
        do {
            guard let images = try context.fetch(Image.fetchRequest()) as? [Image] else {
                return [Image]()
            }
//            return images.map { $0.imageData ?? Data() }.filter{ !$0.isEmpty }
            return images
        }
        catch {
            print("Error: Fetching images failed")
        }
        return [Image]()
    }
    
    func loadPDFs() -> [PDF] {
        do {
            guard let PDFs = try context.fetch(PDF.fetchRequest()) as? [PDF] else {
                return [PDF]()
            }
            
            if PDFs.count == 0 {
                FileManager.getDataFromDefaultDocuments().forEach { save(pdfWithData: $0) }
            }
//            return PDFs.map{ $0.pdfData ?? Data() }.filter{ !$0.isEmpty }
            return PDFs
        }
        catch {
            print("Error: Fetching documents failed")
        }
        return [PDF]()
    }
}
