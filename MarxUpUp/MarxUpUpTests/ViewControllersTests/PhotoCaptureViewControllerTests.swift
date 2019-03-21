//
//  PhotoCaptureViewControllerTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 17.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class PhotoCaptureViewControllerTests: XCTestCase {

    var controller: PhotoCaptureViewController!
    let camera = MockCamera()

    override func setUp() {
        super.setUp()
        controller = Storyboard.main.viewController(fromClass: PhotoCaptureViewController.self)
        controller.setCustomCamera(camera)
    }

    override func tearDown() {
        super.tearDown()
        controller = nil
    }

    func testTakePhotoIsCalled() {
        controller.onTakePhotoTap(UIButton())
        XCTAssertTrue(camera.takePhotoIsCalled)
    }

    func testStopIsCalled() {
        controller.viewDidDisappear(false)
        XCTAssertTrue(camera.stopIsCalled)
    }

    func testSwitchPositionIsCalled() {
        controller.onSwitchCameraTap(UIButton())
        XCTAssertTrue(camera.switchPositionIsCalled)
    }

    func testAlertionIsDisplayedWhenCameraIsNotSupported() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()

        _ = controller?.viewDidLoad()
        let presented = controller?.presentedViewController

        XCTAssert(presented?.isMember(of: UIAlertController.self) ?? false)
    }
}

class MockCamera: CameraInterface {

    var switchPositionIsCalled = false
    var stopIsCalled = false
    var takePhotoIsCalled = false
    var updateOrientationIsCalled = false
    var startIsCalled = false
    var updateOrientationisCalled = false

    private var supported = true

    func switchPosition() {
        switchPositionIsCalled = true
    }

    func stop() {
        stopIsCalled = true
    }

    func takePhoto() {
        takePhotoIsCalled = true
    }

    func updateOrientation(forView view: UIView) {
        updateOrientationIsCalled = true
    }

    func setNotSupported() {
        supported = false
    }

    var isSupportedByTheDevice: Bool {
        return supported
    }

    func start() {
        startIsCalled = true
    }

    func updateOrientation(forView view: UIView, withSize size: CGSize) {}
}
