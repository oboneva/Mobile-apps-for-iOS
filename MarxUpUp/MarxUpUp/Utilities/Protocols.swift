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

protocol LocalContentManaging: ContentLoading, ContentSaving, ContentUpdating, ContentDeleting {}

protocol ContentLoading {
    func loadPDFs() -> [LocalContentModel]
    func loadImages() -> [LocalContentModel]
}

protocol ContentSaving {
    func saveImageWithData(_ data: Data)
    func savePDFWithData(_ data: Data)
}

protocol ContentUpdating {
    func updatePDF(_ id: URL, withData data: Data)
    func updateImage(_ id: URL, withData data: Data)
}

protocol ContentDeleting {
    func deleteImage(_ id: URL)
    func deletePDF(_ id: URL)
}

protocol CameraInterface: AnyObject {
    func switchPosition()
    func stop()
    func start()
    func takePhoto()
    func updateOrientation(forView view: UIView, withSize size: CGSize)
    var isSupportedByTheDevice: Bool { get }
}

protocol Annotating: AnyObject {
    
    var isThereUnsavedWork: Bool { get }
    
    func beginAnnotating(atPoint point: CGPoint)
    func continueAnnotating(atPoint point: CGPoint)
    func endAnnotating(atPoint point: CGPoint)
    func reset()
    func save()
}
