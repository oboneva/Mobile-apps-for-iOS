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
    
    private var imagesDataSource: ImagePreviewTableViewDataSource!
    private let tabsDataSource = TabsCollectionViewDataSource()
    
    var initialDataFilter = DataFilter(local: false, sort: ImageSort.Viral)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imagesDataSource == nil {
            imagesDataSource = ImagePreviewTableViewDataSource(withImagesFilteredBy: initialDataFilter)
        }
        
        configImagesTable()
        configTabsCollection()
        addRefreshControl()
        
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if tabsCollectionView.indexPathsForSelectedItems?.count == 0 {
            collectionView(tabsCollectionView, didSelectItemAt: tabsDataSource.defaultSelectedTabIndex)
        }
    }
    
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
    
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshImagesTableViewData(_:)), for: UIControl.Event.valueChanged)
        imagesTableView.insertSubview(refreshControl, at: 0)
        imagesTableView.refreshControl = refreshControl
    }
    
    @objc func refreshImagesTableViewData(_ refreshControl: UIRefreshControl) {
        imagesDataSource.refreshData { _ in
            DispatchQueue.main.async {
                self.imagesTableView.reloadData()
                self.imagesTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func shouldLoadNewData(forScrollView scrollView: UIScrollView) -> Bool {
        return scrollView == imagesTableView && scrollView.contentOffset.y > imagesTableView.contentSize.height - imagesTableView.bounds.size.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldLoadNewData(forScrollView: scrollView) && scrollView.isDragging {
            activityIndicator.startAnimating()
            imagesDataSource.addData { newDataCount in
                if let count = newDataCount {
                    let allDataCount = self.imagesDataSource.imagesCount
                    let newIndexPaths = Array((allDataCount - count)..<allDataCount).map {IndexPath(item: $0, section: 0)}
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imagesTableView.reloadData()
    }
    
    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ImagesPreviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imagesDataSource.loadData(withFilter: tabsDataSource.filter(atIndex: indexPath.item)) { _ in
            DispatchQueue.main.async {
                self.imagesTableView.reloadData()
            }
        }
    }
}

extension ImagesPreviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let annotateImageController = SingleImageViewController.instantiateFromStoryboard(storyborad: Storyboard.Annotate) as? SingleImageViewController else {
            return
        }
        annotateImageController.image = imagesDataSource.getImage(atIndex: indexPath.row)
        annotateImageController.updateDatabaseDelegate = imagesDataSource
        imagesDataSource.selectedModelIndexForUpdate = indexPath.row
        present(annotateImageController, animated: true, completion: nil)
    }
}

extension ImagesPreviewViewController{
    func setDependencies(_ imagesDataSource: ImagePreviewTableViewDataSource) {
        self.imagesDataSource = imagesDataSource
    }
}
