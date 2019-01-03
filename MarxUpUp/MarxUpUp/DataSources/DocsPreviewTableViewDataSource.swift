//
//  DocsPreviewTableViewDataSource.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 8.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit
import PDFKit

class DocsPreviewTableViewDataSource: NSObject {
    private let databaseManager: LocalContentManaging
    private var documents: [LocalContentModel]
    private let cachedThumbnails = NSCache<NSNumber, UIImage>()
    
    var selectedModelIndexForUpdate: Int?
    
    init(withDatabaseManager DBManager: LocalContentManaging = DatabaseManager()) {
        databaseManager = DBManager
        documents = databaseManager.loadPDFs()
        super.init()
    }
    
    func reloadData() {
        documents = databaseManager.loadPDFs()
    }

    func image(atIndex index: Int, forDocument document: PDFDocument, imageRect cellRect:CGRect) -> UIImage {
        let NSIndex = NSNumber(integerLiteral: index)
        
        guard let cachedImage = cachedThumbnails.object(forKey: NSIndex) else {
            let image = (document.page(at: 0)?.thumbnail(of: cellRect.size, for: PDFDisplayBox.artBox))!
            
            cachedThumbnails.setObject(image, forKey: NSIndex)
            return image
        }
        
        return cachedImage
    }
    
    func document(atIndex index: Int) -> PDFDocument? {
        return PDFDocument(data: documents[index].data)
    }
}

extension DocsPreviewTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(fromClass: PDFTableViewCell.self, forIndexPath: indexPath)
        guard let document = PDFDocument(data: documents[indexPath.row].data) else {
            return cell
        }
        
        cell.PDFThumbnailView.image = image(atIndex: indexPath.row, forDocument:document, imageRect: cell.PDFThumbnailView.frame)
        cell.PDFThumbnailView.layer.borderColor = UIColor.orange.cgColor
        cell.PDFThumbnailView.layer.borderWidth = 2.0
        cell.PDFTitleLabel.text = document.documentAttributes![PDFDocumentAttribute.titleAttribute] as? String
        cell.PDFTitleLabel.sizeToFit()
        
        return cell
    }
}

extension DocsPreviewTableViewDataSource: UpdateDatabaseDelegate {
    
    func updateImage(withData data: Data) {
        //stub
        print("Error: This shouldn't be called")
    }
    
    func updatePDF(withData data: Data) {
        guard let index = selectedModelIndexForUpdate else {
            return
        }
        
        let NSIndex = NSNumber(integerLiteral: index)
        cachedThumbnails.removeObject(forKey: NSIndex)
        documents[index].update(data)
        databaseManager.updatePDF(documents[index].id, withData: data)
    }
}
