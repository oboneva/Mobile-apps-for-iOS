//
//  NetworkProtocols.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 18.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

protocol NetworkSession: AnyObject {
    var imagesDataTaskCurrentlyInProgress: Bool? { get }
    func dataTask(with request: URLRequest, completion: @escaping ((Response?, Error?) -> Void)) -> NetworkSessionDataTask
    func allTasks(completionHandler: @escaping ([NetworkSessionDataTask]) -> Void)
}

protocol NetworkSessionDataTask: AnyObject {
    func resume()
    func cancel()
    
    var currentRequest: URLRequest? { get }
}

protocol Parsable: AnyObject {
    func linksFromJSONDict(_ dictionary: [String:AnyObject], countPerPage count: Int, andCompletion handler:([String]) -> Void)
}
