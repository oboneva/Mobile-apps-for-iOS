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
    func dataTask(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkSessionDataTask
    func getAllTasks(completionHandler: @escaping ([URLSessionTask]) -> Void)
}

protocol NetworkSessionDataTask: AnyObject {
    func resume()
    func cancel()
}

extension URLSession: NetworkSession {
    
    var imagesDataTaskCurrentlyInProgress: Bool? { return nil }
    
    func dataTask(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkSessionDataTask {
        return (dataTask(with: with, completionHandler: completionHandler) as URLSessionDataTask) as NetworkSessionDataTask
    }
}

extension URLSessionDataTask: NetworkSessionDataTask {  }
