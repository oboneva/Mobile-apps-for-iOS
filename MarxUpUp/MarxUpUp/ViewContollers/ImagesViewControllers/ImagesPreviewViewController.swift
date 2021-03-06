//
//  ImagesPreviewViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 8.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ImagesPreviewViewController: UIViewController {

    @IBOutlet weak var tabsCollectionView: UICollectionView!
    @IBOutlet weak var imagesTableView: UITableView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imagesFooterView: UIView!

    private var imagesDataSource: ImagePreviewTableViewDataSource!
    private let tabsDataSource = TabsCollectionViewDataSource()

    var initialDataFilter = DataFilter(local: false, sort: ImageSort.viral)

    var tabSize: CGSize {
        return CGSize(width: tabsCollectionView.frame.size.width * 0.33, height: tabsCollectionView.frame.size.height)
    }

// MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if imagesDataSource == nil {
            imagesDataSource = ImagePreviewTableViewDataSource(withImagesFilteredBy: initialDataFilter)
        }

        configImagesTable()
        configTabsCollection()
        addRefreshControl()
        addDefaultLabel()

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if tabsCollectionView.indexPathsForSelectedItems?.isEmpty ?? true {
            collectionView(tabsCollectionView, didSelectItemAt: tabsDataSource.defaultSelectedTabIndex)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard imagesDataSource.selectedModelIndexForUpdate != nil else {
            return
        }
        if !tabsDataSource.filter(atIndex: tabsDataSource.selectedTabIndex.item).isDataLocal {
            self.imagesTableView.scrollToRow(at: IndexPath(row: self.imagesDataSource.selectedModelIndexForUpdate!,
                                                           section: 0), at: .none, animated: false)
            return
        }

        self.imagesDataSource.refreshData { (_) in
            let indexForRefresh = IndexPath(row: self.imagesDataSource.selectedModelIndexForUpdate!, section: 0)
            DispatchQueue.main.async {
                self.imagesTableView.reloadRows(at: [indexForRefresh], with: .none)
                self.imagesTableView.scrollToRow(at: indexForRefresh, at: .none, animated: false)
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        if isMovingFromParent {
            imagesDataSource.viewContainerControllerWillBeDismissed()
        }
        super.viewDidDisappear(animated)
    }

// MARK: - Configure Views
    private func configTabsCollection() {
        tabsCollectionView.dataSource = tabsDataSource
        tabsCollectionView.delegate = self
        tabsCollectionView.isPagingEnabled = true
        tabsCollectionView.showsHorizontalScrollIndicator = false
    }

    private func configImagesTable() {
        imagesTableView.dataSource = imagesDataSource
        imagesTableView.delegate = self
    }

// MARK: Manage Data
    @objc func refreshImagesTableViewData(_ refreshControl: UIRefreshControl) {
        imagesDataSource.refreshData { _ in
            DispatchQueue.main.async {
                self.imagesTableView.reloadData()
                self.imagesTableView.refreshControl?.endRefreshing()
            }
        }
    }

    private func shouldLoadNewData(forScrollView scrollView: UIScrollView) -> Bool {
        return scrollView.panGestureRecognizer.velocity(in: scrollView).y <= 0 && scrollView == imagesTableView &&
            scrollView.contentOffset.y > imagesTableView.contentSize.height - imagesTableView.bounds.size.height
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !activityIndicator.isAnimating && shouldLoadNewData(forScrollView: scrollView) && scrollView.isDragging {
            activityIndicator.startAnimating()
            imagesDataSource.addData { newDataCount in
                if let count = newDataCount {
                    let allDataCount = self.imagesDataSource.imagesCount
                    let newIndexPaths = Array((allDataCount - count)..<allDataCount).map {IndexPath(item: $0,
                                                                                                    section: 0)}
                    DispatchQueue.main.async {
                        self.imagesTableView.insertRows(at: newIndexPaths, with: UITableView.RowAnimation.none)
                        self.imagesTableView.refreshControl?.endRefreshing()
                    }
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }

// MARK: - Other Methods
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshImagesTableViewData(_:)),
                                 for: UIControl.Event.valueChanged)
        imagesTableView.insertSubview(refreshControl, at: 0)
        imagesTableView.refreshControl = refreshControl
    }

    private func addDefaultLabel() {
        let label = UILabel()
        label.text = "No images found :("
        label.sizeToFit()
        self.imagesFooterView.addSubview(label)
        label.isHidden = true
        label.center = self.imagesFooterView.center
    }

    func setSelectedTab(atIndexPath indexPath: IndexPath) {
        let prevIndexPath = tabsDataSource.selectedTabIndex
        tabsDataSource.selectedTabIndex = indexPath
        tabsCollectionView.reloadItems(at: [prevIndexPath, indexPath])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout Methods
extension ImagesPreviewViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tabsDataSource.selectedTabIndex == indexPath {
            return
        }
        setSelectedTab(atIndexPath: indexPath)
        tabsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)

        activityIndicator.startAnimating()
        imagesDataSource.loadData(withFilter: tabsDataSource.filter(atIndex: indexPath.item)) { newImagesCount in
            DispatchQueue.main.async {
                self.imagesTableView.reloadData()
                self.activityIndicator.stopAnimating()
                newImagesCount == 0 ? (self.imagesFooterView.subviews.last?.isHidden = false) :
                    (self.imagesFooterView.subviews.last?.isHidden = true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return tabSize
    }
}

// MARK: - UITableViewDelegate Methods
extension ImagesPreviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let annotateImageController = SingleImageViewController.instantiateFromStoryboard(
            storyborad: Storyboard.annotate) as? SingleImageViewController else {
            return
        }
        annotateImageController.image = imagesDataSource.getImage(atIndex: indexPath.row)
        if annotateImageController.image?.pngData() == nil {
            imagesDataSource.reloadImage(atIndexPath: indexPath) { (data) in
                guard data != nil, let image = UIImage(data: data!) else {
                    return
                }
                annotateImageController.imageIsLoaded(image)
            }
        }
        annotateImageController.updateDatabaseDelegate = imagesDataSource
        imagesDataSource.selectedModelIndexForUpdate = indexPath.row
        navigationController?.pushViewController(annotateImageController, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard imagesDataSource.couldDeleteImage else {
            return []
        }

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            self.imagesDataSource.removeObjectAtIndex(indexPath)
            self.imagesTableView.deleteRows(at: [indexPath], with: .fade)
        }

        return [delete]
    }
}

// MARK: - Set Dependacies For Unit Tests
extension ImagesPreviewViewController {
    func setDependencies(_ imagesDataSource: ImagePreviewTableViewDataSource) {
        self.imagesDataSource = imagesDataSource
    }
}
