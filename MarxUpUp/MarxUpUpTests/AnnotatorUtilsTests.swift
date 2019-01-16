//
//  AnnotatorUtilsTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 4.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class AnnotatorUtilsTests: XCTestCase {

    let expectedRect = CGRect(x: 0, y: 0, width: 10, height: 10)
    
    func testCreationOfRectBetweenCorrectlyPositionedPoints() { //secondX > firstX, secondY > firstY
        let pointBegin = CGPoint(x: 0, y: 0)
        let pointEnd = CGPoint(x: 10, y: 10)
        
        let result = Utilities.rectBetween(pointBegin, pointEnd)
        
        XCTAssertEqual(result.minX, expectedRect.minX, accuracy: 0)
        XCTAssertEqual(result.maxX, expectedRect.maxX, accuracy: 0)
        XCTAssertEqual(result.minY, expectedRect.minY, accuracy: 0)
        XCTAssertEqual(result.maxY, expectedRect.maxY, accuracy: 0)
    }
    
    func testCreationOfRectBetweenPoints_SecondX_st_FirstX() { //secondX < firstX, secondY > firstY
        let pointBegin = CGPoint(x: 10, y: 0)
        let pointEnd = CGPoint(x: 0, y: 10)
        
        let result = Utilities.rectBetween(pointBegin, pointEnd)

        XCTAssertEqual(result.minX, expectedRect.minX, accuracy: 0)
        XCTAssertEqual(result.maxX, expectedRect.maxX, accuracy: 0)
        XCTAssertEqual(result.minY, expectedRect.minY, accuracy: 0)
        XCTAssertEqual(result.maxY, expectedRect.maxY, accuracy: 0)
    }

    func testCreationOfRectBetweenPoints_Second_st_First() { //secondX < firstX, secondY < firstY
        let pointBegin = CGPoint(x: 10, y: 10)
        let pointEnd = CGPoint(x: 0, y: 0)
        
        let result = Utilities.rectBetween(pointBegin, pointEnd)

        XCTAssertEqual(result.minX, expectedRect.minX, accuracy: 0)
        XCTAssertEqual(result.maxX, expectedRect.maxX, accuracy: 0)
        XCTAssertEqual(result.minY, expectedRect.minY, accuracy: 0)
        XCTAssertEqual(result.maxY, expectedRect.maxY, accuracy: 0)
    }
    
    func testCreationOfRectBetweenPoints_SecondY_st_FirstY() { //secondX > firstX, secondY < firstY
        let pointBegin = CGPoint(x: 0, y: 10)
        let pointEnd = CGPoint(x: 10, y: 0)
        
        let result = Utilities.rectBetween(pointBegin, pointEnd)

        XCTAssertEqual(result.minX, expectedRect.minX, accuracy: 0)
        XCTAssertEqual(result.maxX, expectedRect.maxX, accuracy: 0)
        XCTAssertEqual(result.minY, expectedRect.minY, accuracy: 0)
        XCTAssertEqual(result.maxY, expectedRect.maxY, accuracy: 0)
    }
    
    func testsRotateBezierPathBy180DegreesAroundPoint() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 10))
        let expected = path
        
        Utilities.rotateBezierPath(path, aroundPoint: CGPoint(x: 5, y: 5), withAngle: .pi)
        
        XCTAssertEqual(path, expected)
    }
    
    func testRotateBezierPathBy90DegreesAroundPoint() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 5))
        path.addLine(to: CGPoint(x: 5, y: 5))
        
        Utilities.rotateBezierPath(path, aroundPoint: CGPoint(x: 5, y: 5), withAngle: -.pi / 2)
        
        let expected = UIBezierPath()
        expected.move(to: CGPoint(x: 0, y: 5))
        expected.addLine(to: CGPoint(x: 5, y: 5))
        
        XCTAssertEqual(expected, path)
    }
}
