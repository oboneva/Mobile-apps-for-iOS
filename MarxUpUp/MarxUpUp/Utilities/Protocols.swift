//
//  Protocols.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 15.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

protocol ToolboxItemDelegate: AnyObject {
    func didChoose(textAnnotationFromType type: ToolboxItemType)
    func didChoosePen()
    func didChoose(_ option: Int, forToolboxItem type: ToolboxItemType)
    func didChoose(lineWidth width: Float)
    func didChooseColor(_ color: UIColor)
}

protocol ToolbarButtonsDelegate: AnyObject {
    func didSelectAnnotate()
    func didSelectSave()
    func didSelectReset()
    func didSelectToolbox()
}

protocol EditedContentStateDelegate: AnyObject {
    func didSelectUndo()
    func didSelectRedo()
}

protocol UpdateDatabaseDelegate: AnyObject {
    func updatePDF(withData data: Data)
    func updateImage(withData data: Data)
}

protocol DrawDelegate: AnyObject {
    func willBeginDrawing()
}
protocol CameraInterface: AnyObject {
    func switchPosition()
    func stop()
    func takePhoto()
    func updateOrientation(forView view: UIView)
    var isSupportedByTheDevice: Bool { get }
}
