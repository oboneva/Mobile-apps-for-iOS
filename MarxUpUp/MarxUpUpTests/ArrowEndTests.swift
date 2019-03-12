//
//  ArrowEndTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 4.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class ArrowEndTests: XCTestCase {

    let points = [CGPoint(x: 0, y: 30), CGPoint(x: 10, y: 10), CGPoint(x: 20, y: 30)]
    let point = CGPoint(x: 10, y: 10)

    func testOpenArrow() {
        let result = ArrowBezierPath.endLine(atPoint: point, fromType: .open)

        let expectedPath = UIBezierPath()
        expectedPath.move(to: points[0])
        points.forEach({ expectedPath.addLine(to: $0)})

        XCTAssertEqual(result, expectedPath)
    }

    func testClosedArrow() {
        let result = ArrowBezierPath.endLine(atPoint: point, fromType: .closed)

        let expectedPath = UIBezierPath()
        expectedPath.move(to: points[0])
        points.forEach({ expectedPath.addLine(to: $0)})
        expectedPath.close()

        XCTAssertEqual(result, expectedPath)
    }
}
