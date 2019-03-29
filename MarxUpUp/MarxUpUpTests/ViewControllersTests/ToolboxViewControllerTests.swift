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

    var imageController: SingleImageViewController!
    var controller: ToolboxStackController!
    let toolboxItemDelegate = TextFakeDelegate()
    let annotator = MockAnnotator()

    override func setUp() {
        super.setUp()
        imageController = Storyboard.annotate.viewController(fromClass: SingleImageViewController.self)
        imageController.setDependancies(annotator)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = imageController
        window.makeKeyAndVisible()

        controller = imageController.toolboxDelegate
    }

    override func tearDown() {
        imageController = nil
    }

    func testRedoIsCalledOnRedoButtonTap() {
        guard let buttons = controller.view?.subviews.filter({ $0.isMember(of: UIButton.self) }) else {
            XCTFail("No buttons in the toolbox")
            return
        }

        let redoButton = buttons.last as? UIButton
        redoButton?.sendActions(for: .allEvents)
        XCTAssertTrue(annotator.redoIsCalled)
    }

    func testUndoIsCalledOnUndoButtonTap() {
        guard let buttons = controller.view?.subviews.filter({ $0.isMember(of: UIButton.self) }) else {
            XCTFail("No buttons in the toolbox")
            return
        }

        let undoButton = buttons[buttons.count - 2] as? UIButton
        undoButton?.sendActions(for: .allEvents)
        XCTAssertTrue(annotator.undoIsCalled)
    }

    func testDidChoosePenIsCalledOnPenButtonTap() {
        guard let buttons = controller.view?.subviews.filter({ $0.isMember(of: UIButton.self) }) else {
            XCTFail("No buttons in the toolbox")
            return
        }

        let penButton = buttons.first as? UIButton
        penButton?.sendActions(for: .allEvents)
        XCTAssertTrue(annotator.didChoosePenIsCalled)
    }

    func testLineWidthControllerIsPresentedModalyOnWidthButtonTap() {
        guard let buttons = controller.view?.subviews
            .filter({ $0.isMember(of: UIButton.self) })
            .map({ $0 as? UIButton }) else {
                XCTFail("No buttons in the toolbox")
                return
        }

        let widthButton = buttons[3]
        widthButton?.sendActions(for: .allEvents)
        XCTAssertTrue(imageController.presentedViewController?.isMember(of: LineWidthViewController.self) ?? false)
        XCTAssertEqual(imageController.presentedViewController?.modalPresentationStyle,
                       UIModalPresentationStyle.popover)
    }

    func testColorPickerControllerIsPresentedModalyOnColorButtonTap() {
        guard let buttons = controller.view?.subviews
            .filter({ $0.isMember(of: UIButton.self) })
            .map({ $0 as? UIButton }) else {
                XCTFail("No buttons in the toolbox")
                return
        }

        let colorButton = buttons[1]
        colorButton?.sendActions(for: .allEvents)

        XCTAssertTrue(imageController.presentedViewController?.isMember(of: ColorPickerViewController.self) ?? false)
        XCTAssertEqual(imageController.presentedViewController?.modalPresentationStyle,
                       UIModalPresentationStyle.popover)
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
