//
//  ToolboxViewControllerTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 12.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class ToolboxViewControllerTests: XCTestCase {
    
    var controller: ToolboxViewController!
    let toolboxItemDelegate = TextFakeDelegate()
    let editedContentDelegate = FakeEditedContentDelegate()
    let drawDelegate = FakeDrawDelegate()

    override func setUp() {
        super.setUp()
        
        controller = Storyboard.Toolbox.initialViewController() as? ToolboxViewController
        controller.contentType = .PDF
        _ = controller?.view
        
        controller?.toolboxItemDelegate = toolboxItemDelegate
        controller?.drawDelegate = drawDelegate
        controller?.editedContentStateDelegate = editedContentDelegate
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
    
    override func tearDown() {
        controller = nil
    }

    func testRedoIsCalledOnRedoButtonTap() {
        guard let buttons = controller?.view.subviews.filter({ $0.isMember(of: UIButton.self) }) else {
            XCTFail()
            return
        }
        
        let redoButton = buttons.last as? UIButton
        redoButton?.sendActions(for: .allEvents)
        XCTAssertTrue(editedContentDelegate.redoIsCalled)
    }
    
    func testUndoIsCalledOnUndoButtonTap() {
        guard let buttons = controller?.view.subviews.filter({ $0.isMember(of: UIButton.self) }) else {
            XCTFail()
            return
        }
        
        let undoButton = buttons[buttons.count - 2] as? UIButton
        undoButton?.sendActions(for: .allEvents)
        XCTAssertTrue(editedContentDelegate.undoIsCalled)
    }
    
    func testDidChoosePenIsCalledOnPenButtonTap() {
        guard let buttons = controller?.view.subviews.filter({ $0.isMember(of: UIButton.self) }) else {
            XCTFail()
            return
        }
        
        let penButton = buttons.first as? UIButton
        penButton?.sendActions(for: .allEvents)
        XCTAssertTrue(toolboxItemDelegate.didChoosePenIsCalled)
    }
    
    func testDrawDelegateIsCalledOnPenArrowAndShapeButtonTap() {
        let arrowPenAndShapeButtonTags = [0, 2, 4]
        guard let buttons = controller?.view.subviews.filter({ $0.isMember(of: UIButton.self) }).map({ $0 as? UIButton }).filter({ arrowPenAndShapeButtonTags.contains($0?.tag ?? -1) }) else {
            XCTFail()
            return
        }
        
        buttons.forEach({
            $0?.sendActions(for: .allEvents)
        })
        
        XCTAssertEqual(3, drawDelegate.timesCalled)
    }
    
    func testTextAnnotationIsCalledForPDFContentType() {
        let textAnnotationButtonTags = [5, 6, 7]
        guard let buttons = controller?.view.subviews.filter({ $0.isMember(of: UIButton.self) }).map({ $0 as? UIButton }).filter({ textAnnotationButtonTags.contains($0?.tag ?? -1) }) else {
            XCTFail()
            return
        }
        
        buttons.forEach({
            $0?.sendActions(for: .allEvents)
        })
        
        XCTAssertEqual(3, toolboxItemDelegate.timesTextAnnotationIsCalled)
    }
    
    func testLineWidthControllerIsPresentedModalyOnWidthButtonTap() {
        guard let buttons = controller?.view.subviews.filter({ $0.isMember(of: UIButton.self) }).map({ $0 as? UIButton }) else {
            XCTFail()
            return
        }
        
        let widthButton = buttons[3]
        widthButton?.sendActions(for: .allEvents)
        XCTAssertTrue(controller?.presentedViewController?.isMember(of: LineWidthViewController.self) ?? false)
        XCTAssertEqual(controller?.presentedViewController?.modalPresentationStyle, UIModalPresentationStyle.popover)
    }
    
    func testColorPickerControllerIsPresentedModalyOnColorButtonTap() {
        guard let buttons = controller?.view.subviews.filter({ $0.isMember(of: UIButton.self) }).map({ $0 as? UIButton }) else {
            XCTFail()
            return
        }
        
        let colorButton = buttons[1]
        colorButton?.sendActions(for: .allEvents)
        
        XCTAssertTrue(controller?.presentedViewController?.isMember(of: ColorPickerViewController.self) ?? false)
        XCTAssertEqual(controller?.presentedViewController?.modalPresentationStyle, UIModalPresentationStyle.popover)
    }
    
}

class FakeEditedContentDelegate: EditedContentStateDelegate {
    
    var undoIsCalled = false
    var redoIsCalled = false
    
    func didSelectUndo() {
        undoIsCalled = true
    }
    
    func didSelectRedo() {
        redoIsCalled = true
    }
}

class FakeDrawDelegate: DrawDelegate {
    
    var willBeginDrawingIsCalled = false
    var timesCalled = 0
    
    func willBeginDrawing() {
        willBeginDrawingIsCalled = true
        timesCalled += 1
    }
}

class TextFakeDelegate: FakeToolboxItemDelegate {
    
    var timesTextAnnotationIsCalled = 0
    
    override func didChoose(textAnnotationFromType type: ToolboxItemType) {
        didChooseTextAnnotationIsCalled = true
        timesTextAnnotationIsCalled += 1
    }
}
