//
//  DocsPreviewViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 8.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class DocsPreviewViewController: UIViewController {

    @IBOutlet weak var PDFTableView: UITableView!
    var dataSource: DocsPreviewTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dataSource == nil {
            dataSource = DocsPreviewTableViewDataSource()
        }
        
        PDFTableView.dataSource = dataSource
        PDFTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.PDFTableView.reloadData()
        guard dataSource.selectedModelIndexForUpdate != nil else {
            return
        }
        let indexForRefresh = IndexPath(row: dataSource.selectedModelIndexForUpdate!, section: 0)
        
        DispatchQueue.main.async {
            self.PDFTableView.reloadRows(at: [indexForRefresh], with: .none)
            self.PDFTableView.scrollToRow(at: indexForRefresh, at: .top, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
}

extension DocsPreviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let controller = SingleDocumentViewController.instantiateFromStoryboard(storyborad: Storyboard.Annotate) as? SingleDocumentViewController else {
            print("Error: SingleDocumentViewController cannot be instantiated from storyboard")
            return
        }
        controller.document = dataSource.document(atIndex: indexPath.row)
        controller.updateDatabaseDelegate = dataSource
        dataSource.selectedModelIndexForUpdate = indexPath.row
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.dataSource.removeObjectAtIndexPath(indexPath)
            self.PDFTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete]
    }
    
}

extension DocsPreviewViewController {
    func setDependencies(_ dataSource: DocsPreviewTableViewDataSource) {
        self.dataSource = dataSource
    }
}
