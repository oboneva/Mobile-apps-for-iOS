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
    
    let filter = DataFilter(local: false, sort: .None)
    let requester = ImageDataRequester(withSession: MockNetworkSession(), andParser: MockParserImages())
    let cache = NSCache<NSString, UIImage>()
    let DBManager = MockDatabaseManager()
    
    var dataSource: MockImagePreviewTableViewDataSource!
    var controller: ImagesPreviewViewController!

    override func setUp() {
        super.setUp()
        controller = Storyboard.PreviewContent.viewController(fromClass: ImagesPreviewViewController.self)
        dataSource = MockImagePreviewTableViewDataSource(withImagesFilteredBy: filter, requester, cache, DBManager)
        controller.setDependencies(dataSource)
        
        _ = controller.view
    }

    override func tearDown() {
        controller = nil
        dataSource = nil
        super.tearDown()
    }

    func testDidSelectContentSortTab() {
        let index = IndexPath(item: 0, section: 0)
        guard let tabsDataSource = controller.tabsCollectionView.dataSource as? TabsCollectionViewDataSource else {
            XCTFail()
            return
        }
        
        controller.collectionView(controller.tabsCollectionView, didSelectItemAt:index)
        
        XCTAssertEqual(dataSource.filter, tabsDataSource.filter(atIndex: index.item))
        XCTAssertTrue(dataSource.loadDataIsCalled)
    }
    
    func testDidSelectImage() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()
        
        let index = IndexPath(item: 0, section: 0)
        controller.tableView(controller.imagesTableView, didSelectRowAt: index)
        
        guard let presentedController = controller.presentedViewController as? SingleImageViewController else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(presentedController.updateDatabaseDelegate != nil)
        XCTAssertEqual(index.row, dataSource.selectedModelIndexForUpdate)
        XCTAssertEqual(presentedController.image.pngData(), UIImage(named: "test-image")?.pngData())
    }
   
}

class MockImagePreviewTableViewDataSource: ImagePreviewTableViewDataSource {
    var loadDataIsCalled = false
    var filter: DataFilter?
    
    override func loadData(withFilter filter: DataFilter, withCompletion handler: @escaping (Int?) -> Void) {
        self.filter = filter
        loadDataIsCalled = true
    }
    
    override func getImage(atIndex index: Int) -> UIImage {
        return UIImage(named: "test-image") ?? UIImage()
    }
}
