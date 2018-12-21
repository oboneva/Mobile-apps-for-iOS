//
//  NetworkResponseParser.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 20.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//


import UIKit

class NetworkResponseParser: NSObject, Parsable {
    func linksFromJSONDict(_ dictionary: [String:AnyObject], countPerPage count: Int, andCompletion handler:([String]) -> Void) {
        guard let data = dictionary["data"] as? [[String: AnyObject]] else {
            return
        }
        var links = [String]()
        
        data.forEach { (subDict) in
            if let arrayOfImageDicts = subDict["images"] as? [[String: AnyObject]], let imageDict = arrayOfImageDicts.first, shouldAddImage(withDictionary: imageDict), let link = imageDict["link"] as? String {
                links.append(link)
                if links.count > count {
                    handler(links)
                    links.removeAll()
                }
            }
        }
        
        if links.count > 0 {
            handler(links)
        }
    }
    
    private func shouldAddImage(withDictionary dict: [String: AnyObject]) -> Bool {
        guard let link = dict["link"] as? String, let animated = dict["animated"] as? Bool else {
            return false
        }
        return !link.contains("http:") && !animated
    }
}
