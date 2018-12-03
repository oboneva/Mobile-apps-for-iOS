//
//  ImageDataRequester.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 12.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ImageDataRequester: NSObject {
    
    private var url: URL? {
        get {
            return URL(string: "https://api.imgur.com/3/gallery/hot/" + sort.description + "/day/" + page.description + "?showViral=true&mature=false&album_previews=false")
        }
    }
    private var request : URLRequest? {
        get {
            guard let unwrappedURL = url else {
                return  nil
            }
            var request = URLRequest(url: unwrappedURL)
            request.httpMethod = HTTPMethod
            request.addValue(authorizationValue, forHTTPHeaderField: authorizationKey)
            
            return request
        }
    }
    private var chunkSize: Int {
        get {
            return 100
        }
    }
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    private let HTTPMethod = "GET"
    private let authorizationKey = "Authorization"
    private let authorizationValue = "Client-ID *YOUR-ID*"
    
    private var page = 1
    private var sort = ImageSort.Viral
    private var areImageIDsLoading = false
    
    private let key_id = "id"
    private let key_images = "images"
    private let key_link = "link"
    private let key_data = "data"
    private let key_animated = "animated"
    private let key_status = "status"
    
    
    func imageData(withLink link: String, andCompletion handler: @escaping (Data?) -> Void) {
        guard let url = URL(string: link) else {
            return
        }
    
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error:")
                return
            }
            
            handler(data)
        }
        task.resume()
    }
    
    func cancelCurrentRequests(WithCompletion handler: @escaping () -> Void) {
        session.getAllTasks { (tasks) in
            let filtered = tasks.filter({ $0.currentRequest == self.request})
            filtered.forEach({ (task) in task.cancel() })
            handler()
        }
    }
    
    func getImageLinks(sortedBy sort: ImageSort, withCompletion handler: @escaping ([String]?) -> Void) {
        guard areImageIDsLoading == false else {
            return
        }

        if self.sort != sort {
            page = 1;
            self.sort = sort
        }
        
        areImageIDsLoading = true
        guard request != nil else {
            print("Error: Request is nil")
            return
        }
        
        let task = session.dataTask(with: request!) { (data, response, error) in
            guard let unwrappedData = data, error == nil else {
                print("Error: No data or error")
                handler(nil)
                return
            }
            guard let dataDict = try? JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:AnyObject] else {
                print("Error: Unwrapping")
                handler(nil)
                return
            }
            let statusCode = dataDict?[self.key_status] as? Int
            guard statusCode != nil else {
                print("Error: Status code is nil")
                handler(nil)
                return
            }
            
            if statusCode == 200 {
                guard let unwrappedDict = dataDict else {
                    print("Error: Unwrapping data response to image links request")
                    handler(nil)
                    return
                }
                self.linksFromJSONDict(unwrappedDict, withCount: self.chunkSize) { links in
                    handler(links)
                }
            }
            else {
                print("Error: Status code is not 200")
                handler(nil)
            }
            self.areImageIDsLoading = false
        }
        task.resume()
        page = page + 1
    }
    
    func linksFromJSONDict(_ dictionary: [String:AnyObject], withCount count: Int, andCompletion handler:([String]) -> Void) {
        guard let data = dictionary[key_data] as? [[String: AnyObject]] else {
            return
        }
        var links = [String]()
        
        data.forEach { (subDict) in
             if let arrayOfImageDicts = subDict[key_images] as? [[String: AnyObject]], let imageDict = arrayOfImageDicts.first, shouldAddImage(withDictionary: imageDict), let link = imageDict[key_link] as? String {
                links.append(link)
                if links.count > chunkSize {
                    handler(links)
                    links.removeAll()
                }
        }
    }
        if links.count > 0 {
            handler(links)
        }
    
    
    func shouldAddImage(withDictionary dict: [String: AnyObject]) -> Bool {
        guard let link = dict[key_link] as? String, let animated = dict[key_animated] as? Bool else {
            return false
        }
        return !link.contains("http:") && !animated
    }
}

    func setPageToFirst() {
        page = 1;
    }
}
