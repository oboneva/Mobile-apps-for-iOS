//
//  ImageDataRequesterTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 18.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class ImageDataRequesterTests: XCTestCase {

    var requester: ImageDataRequester!
    let session = MockNetworkSession()
    let parser = MockParser()

    override func setUp() {
        super.setUp()
        requester = ImageDataRequester(withSession: session, andParser: parser)
    }

    override func tearDown() {
        requester = nil
        super.tearDown()
    }

    func testTheURLIsRequested() {
        let url = "https://api.imgur.com/3/gallery/hot/viral/day/1?showViral=true&mature=false&album_previews=false"

        requester.getImageLinks(sortedBy: ImageSort.Viral){ (_) in }

        XCTAssertEqual(session.url?.absoluteString ?? "", url)
    }

    func testDataTaskWasStarted() {
        let dataTask = MockNetworkSessionDataTask()
        session.mockDataTask = dataTask

        requester.getImageLinks(sortedBy: .Viral, withCompletion: { (_) in })
        XCTAssertTrue(dataTask.resumeIsCalled)
    }

    func testAllTasksAreCancelled() {
        guard let url = URL(string: "https://api.imgur.com/3/gallery/hot/viral/day/1?showViral=true&mature=false&album_previews=false") else {
            print("fck")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Client-ID *YOUR-ID*", forHTTPHeaderField: "Authorization")

        let dataTask = MockNetworkSessionDataTask(withRequest: request)
        let dataTask2 = MockNetworkSessionDataTask(withRequest: request)
        session.mockAllDataTasks = [dataTask, dataTask2]

        requester.cancelCurrentRequests(WithCompletion: {  })
        XCTAssertTrue(dataTask.cancelIsCalled)
        XCTAssertTrue(dataTask2.cancelIsCalled)
    }

    func testPagePropertyIsUpdated() {
        requester.getImageLinks(sortedBy: .Viral, withCompletion: { (_) in })
        requester.getImageLinks(sortedBy: .Viral, withCompletion: { (_) in })
        requester.getImageLinks(sortedBy: .Viral, withCompletion: { (_) in })

        XCTAssertEqual(session.url?.absoluteString , "https://api.imgur.com/3/gallery/hot/viral/day/3?showViral=true&mature=false&album_previews=false")

    }

    func testPageIsReset() {
        requester.getImageLinks(sortedBy: .Viral, withCompletion: { (_) in })
        requester.getImageLinks(sortedBy: .Viral, withCompletion: { (_) in })
        requester.getImageLinks(sortedBy: .Date, withCompletion: { (_) in })

        XCTAssertEqual(session.url?.absoluteString, "https://api.imgur.com/3/gallery/hot/time/day/1?showViral=true&mature=false&album_previews=false")
    }

    func testResponseContainsError() {
        session.mockError = NSError.init(domain: "zxcv", code: 132, userInfo: nil)
        session.mockDataResponse = nil

        requester.getImageLinks(sortedBy: .Viral) { (links) in
            if links != nil {
                XCTFail()
            }
        }
    }

    func testHandlerIsCalledWhenLinksAreAvailable() {
        requester.getImageLinks(sortedBy: .Date) { (links) in
            if links == nil {
                XCTFail()
            }
        }

        XCTAssertTrue(parser.handlerIsCalled)
    }

    func testImageDataWithError() {
        session.mockError = NSError.init(domain: "zxcv", code: 132, userInfo: nil)
        session.mockDataResponse = nil

        requester.imageData(withLink: "fsdfgsdf") { (imageData) in
            if imageData != nil {
                XCTFail()
            }
        }
    }

    func testImageDataWithoutError() {
        requester.imageData(withLink: "fsdfgsdf") { (imageData) in
            if imageData != self.session.mockDataResponse {
                XCTFail()
            }
        }
    }

}

class MockNetworkSession: NetworkSession {
    var usedRequest: URLRequest?
    var url: URL?
    var mockDataTask = MockNetworkSessionDataTask()
    var mockAllDataTasks: [MockNetworkSessionDataTask]?
    var mockDataResponse: Data? = {
        let dict = ["linky" : "sdfgsfdg", "linkr": "s", "link": "sdfgsg"]
        let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return data
    }()
    var mockError: Error?
    var mockResponseStatusCode: Int?

    var imagesDataTaskCurrentlyInProgress: Bool? { return false }
    
    func dataTask(with request: URLRequest, completion: @escaping ((Response?, Error?) -> Void)) -> NetworkSessionDataTask {
        usedRequest = request
        url = request.url
        if mockError != nil {
            completion(nil, mockError)
        }
        else {
            completion(Response(data: mockDataResponse ?? Data(), response: nil), nil)
        }
        
        return mockDataTask
    }

    func allTasks(completionHandler: ([NetworkSessionDataTask]) -> Void) {
        completionHandler(mockAllDataTasks ?? [NetworkSessionDataTask]())
    }
    
    func invalidateAndCancel() { }
}

class MockNetworkSessionDataTask: NetworkSessionDataTask {

    var resumeIsCalled = false
    var cancelIsCalled = false

    func resume() {
        resumeIsCalled = true
    }

    func cancel() {
        cancelIsCalled = true
    }

    var currentRequest: URLRequest?

    init(withRequest request: URLRequest? = nil) {
        currentRequest = request
    }
}

class MockParser: NSObject, Parsable {
    var handlerIsCalled = false

    func linksFromJSONDict(_ dictionary: [String : AnyObject], countPerPage count: Int, andCompletion handler: ([String]) -> Void) {
        let links = ["link", "sdfgsfdg", "link"]
        handler(links)
        handlerIsCalled = true
    }

}
