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
        return URL(string: "https://api.imgur.com/3/gallery/hot/" + sort.description +
            "/day/" + page.description + "?showViral=true&mature=false&album_previews=false")
    }
    private var request: URLRequest? {
        guard let unwrappedURL = url else {
            return  nil
        }
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = HTTPMethod
        request.addValue(authorizationValue, forHTTPHeaderField: authorizationKey)

        return request
    }
    private var chunkSize: Int {
        return 100
    }

    let session: NetworkSession
    private let HTTPMethod = "GET"
    private let authorizationKey = "Authorization"
    private let authorizationValue = "Client-ID *YOUR-ID*"

    private var page = 1
    private var sort = ImageSort.viral
    private var areImageIDsLoading = false

    private let parser: Parsable

    init(withSession session: NetworkSession = URLSession(configuration: URLSessionConfiguration.default),
         andParser parser: Parsable = NetworkResponseParser()) {
        self.session = session
        self.parser = parser
    }

    func imageData(withLink link: String, andCompletion handler: @escaping (Data?) -> Void) {
        guard let url = URL(string: link) else {
            return
        }

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completion: completion(
            onResult: { (result) in
                handler(result.data)
        },
            onError: { (error) in
                print(error)
        }))
        task.resume()
    }

    func cancelCurrentRequests(WithCompletion handler: @escaping () -> Void) {
        session.allTasks { (tasks) in
            let filtered = tasks.filter({ $0.currentRequest == self.request})
            filtered.forEach({ (task) in task.cancel() })
            handler()
        }
    }

    func getImageLinks(sortedBy sort: ImageSort, withCompletion handler: @escaping ([String]?) -> Void) {
        guard areImageIDsLoading == false || session.imagesDataTaskCurrentlyInProgress == false else {
            return
        }

        if self.sort != sort {
            page = 1
            self.sort = sort
        }

        areImageIDsLoading = true
        guard request != nil else {
            print("Error: Request is nil")
            return
        }

        let task = session.dataTask(with: request!, completion: completion(
            onResult: { (result) in
                guard let dataDict = ((try?
                    JSONSerialization.jsonObject(with: result.data,
                                                 options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:AnyObject]) as [String : AnyObject]??),
                    let unwrappedDict = dataDict else {

                    print("Error: Unwrapping failed")
                    handler(nil)
                    return
                }

                self.parser.linksFromJSONDict(unwrappedDict, countPerPage: self.chunkSize) { links in
                    handler(links)
                }

                self.areImageIDsLoading = false
        },
            onError: { (error) in
                print(error)
                handler(nil)
        }))
        task.resume()
        page += 1
    }

    func setPageToFirst() {
        page = 1
    }

    func invalidateSession() {
        session.invalidateAndCancel()
    }
}

extension ImageDataRequester {
    func completion<Result>(onResult: @escaping (Result) -> Void,
                            onError: @escaping (Error) -> Void) -> ((Result?, Error?) -> Void) {
        return { (result, error) in
            if let unwrappedResult = result {
                onResult(unwrappedResult)
            } else if let unwrappedError = error {
                onError(unwrappedError)
            } else {
                onError(SplitError.noResultFound)
            }
        }
    }
}

extension URLSession: NetworkSession {

    var imagesDataTaskCurrentlyInProgress: Bool? { return nil }

    func dataTask(with request: URLRequest,
                  completion: @escaping ((Response?, Error?) -> Void)) -> NetworkSessionDataTask {

        return (dataTask(with: request, completionHandler: { (data, response, error) in
            if let unwrappedData = data {
                completion(Response(data: unwrappedData, response: response), nil)
            } else if let unwrappedError = error {
                completion(nil, unwrappedError)
            }
        }) as URLSessionDataTask) as NetworkSessionDataTask
    }

    func allTasks(completionHandler: @escaping ([NetworkSessionDataTask]) -> Void) {
        getAllTasks { (tasks) in
            completionHandler(tasks.filter({ $0.isMember(of: URLSessionDataTask.self)}) as! [NetworkSessionDataTask])
        }
    }
}

extension URLSessionDataTask: NetworkSessionDataTask {  }

struct Response {
    let data: Data
    let response: URLResponse?
}
