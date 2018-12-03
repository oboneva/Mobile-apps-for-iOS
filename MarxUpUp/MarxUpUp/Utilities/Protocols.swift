//
//  Protocols.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 15.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

protocol ToolboxItemDelegate: class {
    func didChoose(textAnnotationFromType type: ToolboxItemType)
    func didChoosePen()
    func didChoose(_ option: Int, forToolboxItem type: ToolboxItemType)
    func didChoose(lineWidth width: Float)
    func didChooseColor(_ color: UIColor)
}

protocol ToolbarButtonsDelegate: class {
    func didSelectAnnotate()
    func didSelectSave()
    func didSelectReset()
    func didSelectToolbox()
}

protocol EditedContentStateDelegate: class {
    func didSelectUndo()
    func didSelectRedo()
}

protocol UpdateDatabaseDelegate: class {
    func updatePDF(withData data: Data)
    func updateImage(withData data: Data)
}

protocol DrawDelegate: class {
    func willBeginDrawing()
}
