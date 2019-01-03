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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
}

extension DocsPreviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let controller = SingleDocumentViewController.instantiateFromStoryboard(storyborad: Storyboard.Annotate) as? SingleDocumentViewController else {
            print("Error: SingleDocumentViewController cannnot be instantiated from storyboard")
            return
        }
        controller.document = dataSource.document(atIndex: indexPath.row)
        controller.updateDatabaseDelegate = dataSource
        dataSource.selectedModelIndexForUpdate = indexPath.row
        present(controller, animated: true, completion: nil)
    }
}

extension DocsPreviewViewController {
    func setDependencies(_ dataSource: DocsPreviewTableViewDataSource) {
        self.dataSource = dataSource
    }
}
