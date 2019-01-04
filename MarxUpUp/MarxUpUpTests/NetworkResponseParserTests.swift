//
//  NetworkResponseParserTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 20.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class NetworkResponseParserTests: XCTestCase {
    let parser = NetworkResponseParser()
    
    func testReturnedValueDoesNotContainAnimatedPictures() {
        let dict = ["data" : [
            ["images" : [["link": "https:jkkhbjhb", "animated" : false]]],
            ["images" : [["link": "https:jkkjhb", "animated" : true]]],
            ["images" : [["link": "https:jkkhbb", "animated" : false]]]]]
        let expected = ["https:jkkhbjhb", "https:jkkhbb"]
        let expectation = self.expectation(description: "")
        
        parser.linksFromJSONDict(dict as [String : AnyObject], countPerPage: 10) { (links) in
            XCTAssertEqual(links, expected)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1) { error -> Void in if error != nil { XCTFail("Error: No response from the parser.") } }
    }
    
    func testReturnedValuesAreSecure() {
        let dict = ["data" : [
            ["images" : [["link": "http:jkkhbjhb", "animated" : false]]],
            ["images" : [["link": "http:jkkjhb", "animated" : false]]],
            ["images" : [["link": "https:jkkhbb", "animated" : false]]]]]
        let expected = ["https:jkkhbb"]
        let expectation = self.expectation(description: "")
        
        parser.linksFromJSONDict(dict as [String : AnyObject], countPerPage: 10) { (links) in
            XCTAssertEqual(links, expected)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1) { error -> Void in if error != nil { XCTFail("Error: No response from the parser.") } }
    }
    
    func testPagination() {
        let dict = ["data" : [
            ["images" : [["link": "https:jkkhbjhb", "animated" : false]]],
            ["images" : [["link": "https:jkkjhb", "animated" : false]]],
            ["images" : [["link": "https:jkkjhb", "animated" : false]]],
            ["images" : [["link": "https:jkkjhb", "animated" : false]]],
            ["images" : [["link": "https:jkkhbb", "animated" : false]]]]]
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 3
        
        parser.linksFromJSONDict(dict as [String : AnyObject], countPerPage: 2) { (links) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1) { error -> Void in if error != nil { XCTFail("Error: No response from the parser.") } }
    }
}
