//
//  ToolboxViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ToolboxStackController {

    private let dataSource: ToolboxDataSource
    weak var editedContentStateDelegate: EditedContentStateDelegate?
    weak var toolboxItemDelegate: ToolboxItemDelegate?
    weak var drawDelegate: DrawDelegate?
    var contentType = ContentType.image

    weak var view: UIStackView?
    weak var controller: UIViewController?

    init(withStackView view: UIStackView, andParentController controller: UIViewController) {
        self.controller = controller
        self.view = view
        if controller.isMember(of: SingleDocumentViewController.self) {
            contentType = .pdf
        }
        dataSource = ToolboxDataSource(forItemsFromType: contentType)
        ToolboxInitializer.addToolboxItems(toView: view, withTarget: self, #selector(toolboxItemPressed(_:)),
                                           andDataSource: dataSource)
    }

    private func presentOptions(forItem item: ToolboxItemModel, _ button: UIButton) {
        var viewController: UIViewController
        var contentSize: CGSize

        if item.type == ToolboxItemType.width {
            guard let lineWidthController = LineWidthViewController.instantiateFromStoryboard(
                storyborad: Storyboard.toolboxItem) as? LineWidthViewController else {
                print("Error: Width controller cannot be instantiated from the storyboard")
                return
            }
            lineWidthController.toolboxItemDelegate = toolboxItemDelegate
            viewController = lineWidthController
            contentSize = CGSize(width: 130, height: 150)
        } else if item.type == ToolboxItemType.color {
            guard let colorPickerViewController = ColorPickerViewController.instantiateFromStoryboard(
                storyborad: Storyboard.toolboxItem) as? ColorPickerViewController else {
                print("Error: Color controller cannot be instantiated from the storyboard")
                return
            }
            colorPickerViewController.toolboxItemDelegate = toolboxItemDelegate
            viewController = colorPickerViewController
            contentSize = CGSize(width: 220, height: 220)
        } else {
            guard let itemCollectionViewController = ToolboxItemOptionsViewController.instantiateFromStoryboard(
                storyborad: Storyboard.toolboxItem) as? ToolboxItemOptionsViewController else {

                print("Error: Options controller cannot be instantiated from the storyboard")
                return
            }
            itemCollectionViewController.itemType = item.type
            itemCollectionViewController.toolboxItemDelegate = toolboxItemDelegate
            viewController = itemCollectionViewController
            contentSize = CGSize(width: 100, height: 150)
        }

        viewController.modalPresentationStyle = UIModalPresentationStyle.popover
        viewController.popoverPresentationController?.delegate = controller as? UIPopoverPresentationControllerDelegate
        viewController.popoverPresentationController?.sourceView = view
        viewController.popoverPresentationController?.sourceRect = button.frame
        viewController.preferredContentSize = contentSize

        controller?.present(viewController, animated: true, completion: nil)
    }

    @objc private func toolboxItemPressed(_ button: UIButton) {
        let item = dataSource.item(atIndex: button.tag)

        if item.type == ToolboxItemType.undo {
            editedContentStateDelegate?.didSelectUndo()
        } else if item.type == ToolboxItemType.redo {
            editedContentStateDelegate?.didSelectRedo()
        } else if item.type == ToolboxItemType.pen {
            toolboxItemDelegate?.didChoosePen()
            view?.isHidden = true
            view?.superview?.isHidden = true
        } else if item.isTextRelated {
            toolboxItemDelegate?.didChoose(textAnnotationFromType: item.type)
            view?.isHidden = true
            view?.superview?.isHidden = true
        } else if item.containsOptions {
            presentOptions(forItem: item, button)
        }

        if item.isForDrawing {
            drawDelegate?.willBeginDrawing()
        }
    }
}
