//
//  ImagesPreviewViewControllerTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 20.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp

class ImagesPreviewViewControllerTests: XCTestCase {

    let filter = DataFilter(local: false, sort: .none)
    let requester = ImageDataRequester(withSession: MockNetworkSession(), andParser: MockParserImages())
    let cache = NSCache<NSString, UIImage>()
    let DBManager = MockDatabaseManager()

    var dataSource: MockImagePreviewTableViewDataSource!
    var controller: ImagesPreviewViewController!

    override func setUp() {
        super.setUp()
        controller = Storyboard.main.viewController(fromClass: ImagesPreviewViewController.self)
        dataSource = MockImagePreviewTableViewDataSource(withImagesFilteredBy: filter, requester, cache, DBManager)
        controller.setDependencies(dataSource)

        _ = controller.view
    }

    override func tearDown() {
        controller = nil
        dataSource = nil
        super.tearDown()
    }

    func testDidSelectSameContentSortTab() {
        let index = IndexPath(item: 0, section: 0)

        controller.collectionView(controller.tabsCollectionView, didSelectItemAt: index)
        XCTAssertFalse(dataSource.loadDataIsCalled)
    }

    func testDidSelectDifferentContentSortTab() {
        let index = IndexPath(item: 1, section: 0)
        guard let tabsDataSource = controller.tabsCollectionView.dataSource as? TabsCollectionViewDataSource else {
            XCTFail("Instantiation of data source failed.")
            return
        }

        controller.collectionView(controller.tabsCollectionView, didSelectItemAt: index)

        XCTAssertEqual(dataSource.filter, tabsDataSource.filter(atIndex: index.item))
        XCTAssertTrue(dataSource.loadDataIsCalled)
    }

    func testDidSelectImage() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        controller = Storyboard.main.viewController(fromClass: ImagesPreviewViewController.self)
        controller.setDependencies(dataSource)
        window.rootViewController = controller
        window.makeKeyAndVisible()

        let nav = UINavigationController.init(rootViewController: controller)

        let index = IndexPath(item: 0, section: 0)
        _ = controller.viewDidLoad()
        controller.tableView(controller.imagesTableView, didSelectRowAt: index)

        guard let presentedController = nav.presentedViewController as? SingleImageViewController else {
            XCTFail("No presented UIViewController")
            return
        }

        XCTAssertTrue(presentedController.updateDatabaseDelegate != nil)
        XCTAssertEqual(index.row, dataSource.selectedModelIndexForUpdate)
        XCTAssertEqual(presentedController.image?.pngData(), UIImage(named: "test-image")?.pngData())
    }

    func testRowActionsOnLocalContent() {
        dataSource.filter = DataFilter(local: true, sort: .date)
        let actions = controller.tableView(controller.imagesTableView,
                                           editActionsForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(actions?.count, 1)
        XCTAssertEqual(actions?.first?.title, "Delete")
    }

    func testRowActionsOnNonLocalContent() {
        dataSource.filter = DataFilter(local: false, sort: .date)
        let actions = controller.tableView(controller.imagesTableView,
                                           editActionsForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(actions?.count, 0)
    }

}

class MockImagePreviewTableViewDataSource: ImagePreviewTableViewDataSource {
    var loadDataIsCalled = false
    var filter: DataFilter?

    override var couldDeleteImage: Bool {
        return filter?.isDataLocal ?? false
    }

    override func loadData(withFilter filter: DataFilter, withCompletion handler: @escaping (Int?) -> Void) {
        self.filter = filter
        loadDataIsCalled = true
    }

    override func getImage(atIndex index: Int) -> UIImage {
        return UIImage(named: "test-image") ?? UIImage()
    }
}
