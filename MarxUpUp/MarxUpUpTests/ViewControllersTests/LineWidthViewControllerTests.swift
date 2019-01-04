//
//  LineWidthViewControllerTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 11.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class LineWidthViewControllerTests: XCTestCase {

    var controller = Storyboard.ToolboxItem.viewController(fromClass: LineWidthViewController.self) as LineWidthViewController?
    let delegate = LineWidthFakeDelegate()
    var slider: UISlider!
    
    override func setUp() {
        super.setUp()
        controller?.toolboxItemDelegate = delegate
        _ = controller?.view
        slider = controller?.widthSlider
    }
    
    override func tearDown() {
        controller = nil
        slider = nil
        super.tearDown()
    }
    
    func testDelegateIsCalledOnSlide() {
        slider?.setValue(3, animated: false)
        controller?.onSlide(slider!)
        
        XCTAssertTrue(delegate.didChooseLineWidthIsCalled)
    }
    
    func testProperValueIsSendedToDelegate() {
        let width = Float(5)
        slider?.setValue(width, animated: false)
        controller?.onSlide(slider!)
        
        XCTAssertEqual(delegate.width, width)
    }
    
    func testWidthImageChangesOnSlide() {
        let image = controller?.widthImageView.image
        slider?.setValue(3, animated: false)
        controller?.onSlide(slider!)
        
        XCTAssertFalse(image?.pngData() == controller?.widthImageView.image?.pngData())
    }
    
}

class LineWidthFakeDelegate : FakeToolboxItemDelegate {
    var width: Float?
    
    override func didChoose(lineWidth width: Float) {
        didChooseLineWidthIsCalled = true
        self.width = width
    }
}
