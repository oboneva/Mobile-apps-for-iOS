//
//  ToolboxViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ToolboxViewController: UIViewController {

    private var dataSource: ToolboxDataSource?
    weak var editedContentStateDelegate : EditedContentStateDelegate?
    weak var toolboxItemDelegate: ToolboxItemDelegate?
    weak var drawDelegate: DrawDelegate?
    var contentType = ContentType.Image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = ToolboxDataSource(forItemsFromType: contentType)
        if let unwrappedDataSource = dataSource {
            ToolboxInitializer.addToolboxItems(toView: view as? UIScrollView, withTarget: self, #selector(toolboxItemPressed(_:)), andDataSource: unwrappedDataSource)
        }
    }
    
    private func presentOptions(forItem item: ToolboxItemModel, _ button: UIButton) {
        var viewController: UIViewController
        var contentSize: CGSize

        if item.type == ToolboxItemType.Width {
            guard let lineWidthController = LineWidthViewController.instantiateFromStoryboard(storyborad: Storyboard.ToolboxItem) as? LineWidthViewController else {
                print("Error: Width controller cannot be instantiated from the storyboard")
                return
            }
            lineWidthController.toolboxItemDelegate = toolboxItemDelegate
            viewController = lineWidthController
            contentSize = CGSize(width: 130, height: 150)
        }
        else if item.type == ToolboxItemType.Color {
            guard let colorPickerViewController = ColorPickerViewController.instantiateFromStoryboard(storyborad: Storyboard.ToolboxItem) as? ColorPickerViewController else {
                print("Error: Color controller cannot be instantiated from the storyboard")
                return
            }
            colorPickerViewController.toolboxItemDelegate = toolboxItemDelegate
            viewController = colorPickerViewController
            contentSize = CGSize(width: 220, height: 220)
        }
        else {
            guard let itemCollectionViewController = ToolboxItemOptionsViewController.instantiateFromStoryboard(storyborad: Storyboard.ToolboxItem) as? ToolboxItemOptionsViewController else {
                print("Error: Options controller cannot be instantiated from the storyboard")
                return
            }
            itemCollectionViewController.itemType = item.type
            itemCollectionViewController.toolboxItemDelegate = toolboxItemDelegate
            viewController = itemCollectionViewController
            contentSize = CGSize(width: 100, height: 150)
        }
        
        viewController.modalPresentationStyle = UIModalPresentationStyle.popover
        viewController.popoverPresentationController?.delegate = self
        viewController.popoverPresentationController?.sourceView = view
        viewController.popoverPresentationController?.sourceRect = button.frame
        viewController.preferredContentSize = contentSize
        
        present(viewController, animated: true, completion: nil)
    }
    
    @objc private func toolboxItemPressed(_ button: UIButton) {
        guard let item = dataSource?.item(atIndex: button.tag) else {
            return
        }
        
        if item.type == ToolboxItemType.Undo {
            editedContentStateDelegate?.didSelectUndo()
        }
        else if item.type == ToolboxItemType.Redo {
            editedContentStateDelegate?.didSelectRedo()
        }
        else if item.type == ToolboxItemType.Pen {
            toolboxItemDelegate?.didChoosePen()
            view.isHidden = true
        }
        else if item.isTextRelated {
            toolboxItemDelegate?.didChoose(textAnnotationFromType: item.type)
            view.isHidden = true
        }
        else if item.containsOptions {
            presentOptions(forItem: item, button)
        }
        
        if item.isForDrawing {
            drawDelegate?.willBeginDrawing()
        }
    }
}

extension ToolboxViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
