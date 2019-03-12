//
//  NetworkResponseParser.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 20.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//


import UIKit

class NetworkResponseParser: NSObject, Parsable {
    private let key_animated = "animated"
    private let key_images = "images"
    private let key_link = "link"
    private let key_data = "data"

    func linksFromJSONDict(_ dictionary: [String: AnyObject],
                           countPerPage count: Int, andCompletion handler: ([String]) -> Void) {
        guard let data = dictionary[key_data] as? [[String: AnyObject]] else {
            handler([])
            return
        }
        var links = [String]()

        data.forEach { (subDict) in
            if let arrayOfImageDicts = subDict[key_images] as? [[String: AnyObject]],
                let imageDict = arrayOfImageDicts.first, shouldAddImage(withDictionary: imageDict),
                let link = imageDict[key_link] as? String {

                links.append(link)
                if links.count >= count {
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
        guard let link = dict[key_link] as? String, let animated = dict[key_animated] as? Bool else {
            return false
        }
        return !link.contains("http:") && !animated
    }
}
