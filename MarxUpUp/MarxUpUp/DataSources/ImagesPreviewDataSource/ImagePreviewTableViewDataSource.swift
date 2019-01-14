//
//  ImagePreviewTableViewDataSource.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 8.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ImagePreviewTableViewDataSource: NSObject {

    private var imageURLs = [String]()
    private var localImages: [LocalContentModel]
    private var imageCache: NSCache<NSString, UIImage>
    private var filter: DataFilter
    private let imageDataRequester: ImageDataRequester
    private let databaseManager: LocalContentManaging
    
    var selectedModelIndexForUpdate: Int?
    
    var imagesCount: Int {
        if filter.isDataLocal {
            return localImages.count
        }
        return imageURLs.count
    }
    
    init(withImagesFilteredBy filter: DataFilter, _ requester: ImageDataRequester = ImageDataRequester(), _ cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>(), _ databaseManager: LocalContentManaging = DatabaseManager()) {
        self.filter = filter
        self.imageDataRequester = requester
        self.databaseManager = databaseManager
        imageCache = cache
        localImages = databaseManager.loadImages()
        super.init()
    }
    
    func getImage(atIndex index: Int) -> UIImage {
        guard let image = image(atIndex: index) else {
            return UIImage()
        }
        return image
    }
    
    private func localImage(atIndex index: Int) -> LocalContentModel {
        return localImages[index]
    }
    
    private func image(atIndex index: Int) -> UIImage? {
        if filter.isDataLocal {
            guard let localImage = UIImage(data: localImage(atIndex: index).data) else {
                return nil
            }
            return localImage
        }
        guard let image = imageCache.object(forKey: NSString(string: imageURLs[index])) else {
            return nil
        }
        return image
    }
    
    private func set(_ image: UIImage, toCell cell: ImagesPreviewTableViewCell, fromTableView table: UITableView) {
        DispatchQueue.main.async {
            if table.visibleCells.contains(cell) {
                cell.URLImageView.image = image
            }
        }
    }
    
    func loadData(withFilter filter: DataFilter, withCompletion handler: @escaping (Int?) -> Void) {
        self.filter = filter
        addData(byKeepingTheOldOne: false, withCompletion: handler)
    }
}

extension ImagePreviewTableViewDataSource: UpdateDatabaseDelegate {
    func updateImage(withData data: Data) {
        if filter.isDataLocal, let index = selectedModelIndexForUpdate {
            databaseManager.updateImage(localImage(atIndex: index).id, withData: data)
            localImages[index].update(data)
        }
        else {
            databaseManager.saveImageWithData(data)
        }
    }
    
    func updatePDF(withData data: Data) {
        //stub
        print("Error: This shouldn't be called")
    }
}

extension ImagePreviewTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(fromClass: ImagesPreviewTableViewCell.self, forIndexPath: indexPath)
        cell.URLImageView.contentMode = UIView.ContentMode.scaleAspectFit
        let image = self.image(atIndex: indexPath.row)
        
        if image != nil {
            set(image!, toCell: cell, fromTableView: tableView)
        }
        else {
            loadImage(forCell: cell, withIndexPath: indexPath, fromTableView: tableView)
        }
        
        return cell
    }
}

extension ImagePreviewTableViewDataSource {
    private func loadImage(forCell cell: ImagesPreviewTableViewCell, withIndexPath indexPath: IndexPath, fromTableView table: UITableView) {
        guard let url = URL(string: imageURLs[indexPath.row]) else {
            print("Error: URL init from String")
            return
        }
        
        let imageDataHandler : (Data?) -> Void = { data in
            guard let unwrappedData = data, let image = UIImage(data: unwrappedData) else {
                print("Error: Unwrapping data or UIImage init from Data")
                return
            }
            self.imageCache.setObject(image, forKey: NSString(string: self.imageURLs[indexPath.row]))
            self.set(image, toCell: cell, fromTableView: table)
        }
        
        if filter.isDataLocal {
            let data = try? Data(contentsOf: url)
            imageDataHandler(data)
        }
        else {
            imageDataRequester.imageData(withLink: imageURLs[indexPath.row], andCompletion: imageDataHandler)
        }
    }
    
    func addData(withCompletion handler: @escaping (Int?) -> Void) {
        if filter.isDataLocal {
            handler(nil)
            return 
        }
        addData(byKeepingTheOldOne: true, withCompletion: handler)
    }
    
    func refreshData(withCompletion handler: @escaping (Int?) -> Void) {
        imageDataRequester.setPageToFirst()
        addData(byKeepingTheOldOne: false, withCompletion: handler)
    }
    
    private func addData(byKeepingTheOldOne keep: Bool, withCompletion handler: @escaping (Int?) -> Void) {
        imageDataRequester.cancelCurrentRequests {
            if self.filter.isDataLocal {
                self.imageDataRequester.setPageToFirst()
                self.localImages = self.databaseManager.loadImages()
                handler(self.localImages.count)
            }
            else {
                if !keep {
                    self.imageURLs.removeAll()
                    handler(nil)
                }
                self.imageDataRequester.getImageLinks(sortedBy: self.filter.sort) { links in
                    guard let unwrappedLinks = links else {
                        print("Error: No links")
                        return
                    }
                    
                    self.imageURLs.append(contentsOf: unwrappedLinks)
                    handler(unwrappedLinks.count)
                }
            }
        }
    }
}
