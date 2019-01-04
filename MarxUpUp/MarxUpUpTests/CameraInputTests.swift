//
//  CameraInputTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 5.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class CameraInputTests: XCTestCase {

    func testInputFrontCameraIsNil() {
        let input = CameraInput(withPosition: .front)
        XCTAssert(input.deviceInput == nil)
    }

    func testInputBackCameraIsNil() {
        let input = CameraInput(withPosition: .back)
        XCTAssert(input.deviceInput == nil)
    }
    
}
