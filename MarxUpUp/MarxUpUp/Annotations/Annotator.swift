//
//  Annotator.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 9.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit
import PDFKit

class Annotator: NSObject {

    private var content: ContentType!
    private var choosenItem: ToolboxItemType = ToolboxItemType.pen

    private var color: UIColor = UIColor.black
    private var lineWidth: CGFloat = 2.0
    private var endLineStyle: ArrowEndLineType = ArrowEndLineType.open
    private var shape: ShapeType = ShapeType.circle
    private var path: UIBezierPath = UIBezierPath()

    private var annotation: PDFAnnotation?
    private var isAnnotationAdded: Bool = false
    var annotatedPDFView: PDFView?

    var annotatedImage: UIImage?
    private var annotatedImageView: UIImageView?
    private var currentImage: UIImage? {
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    private var shouldAnnotate: Bool {
        return (content == ContentType.image && annotatedImage != nil) ||
                (content == ContentType.pdf && annotatedPDFView != nil)
    }

    private var startPoint: CGPoint!
    private var lastPoint: CGPoint!

    private let changesManager = ChangesManager()

    init(forAnnotating imageView: UIImageView) {
        content = ContentType.image

        guard imageView.image != nil else {
            print("Error: There is no image to annotate.")
            return
        }
        annotatedImageView = imageView
        annotatedImage = imageView.image
    }

    init(forAnnotating PDFView: PDFView) {
        content = ContentType.pdf

        guard PDFView.document != nil else {
            print("Error: There is no document to annotate.")
            return
        }
        annotatedPDFView = PDFView
    }

    // MARK: - BezierPaths based annotating
    private func beginDrawingWithBezierPath(atPoint point: CGPoint) {
        path = UIBezierPath()
        path.lineWidth = lineWidth
        path.move(to: point)
    }

    private func updateBezierPath(withPoint point: CGPoint) {
        if choosenItem == ToolboxItemType.pen {
            path.addLine(to: point)
        } else if choosenItem == ToolboxItemType.shape {
            addShapeWithBezierPath(atPoint: point)
        } else if choosenItem == ToolboxItemType.arrow {
            addArrowWithBezierPath(atPoint: point)
        }
    }

    private func addArrowWithBezierPath(atPoint point: CGPoint) {
        let angle = Utilities.angleBetweenPoint(point, andOtherPoint: startPoint)
        path = ArrowBezierPath.endLine(atPoint: point, fromType: endLineStyle)
        Utilities.rotateBezierPath(path, aroundPoint: point, withAngle: angle)

        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: point.x, y: point.y))

        path.lineWidth = lineWidth
    }

    private func addShapeWithBezierPath(atPoint point: CGPoint) {
        let shapeRect = Utilities.rectBetween(point, startPoint)

        if shape == ShapeType.regularRectangle {
            path = UIBezierPath(rect: shapeRect)
        } else if shape == ShapeType.roundedRectangle {
            path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 2.0)
        } else if shape == ShapeType.circle {
            path = UIBezierPath(ovalIn: shapeRect)
        }

        path.lineWidth = lineWidth
    }

    private func addAnnotationWithCurrentBezierPath() {
        guard let annotationBounds = annotatedPDFView?.currentPage?.bounds(for: PDFDisplayBox.mediaBox) else {
            return
        }
        annotation = PDFAnnotation(bounds: annotationBounds, forType: PDFAnnotationSubtype.ink, withProperties: nil)
        updatePropertiesForAnnotation()
        annotation?.add(path)
        if annotation != nil {
            annotatedPDFView?.currentPage?.addAnnotation(annotation!)
        }
    }

    // MARK: - Updating properties
    private func updateProperty(_ property: Int, fromType itemType: ToolboxItemType) {
        if itemType == ToolboxItemType.width {
            lineWidth = CGFloat(property)
        } else if itemType == ToolboxItemType.arrow && property == ArrowEndLineType.open.rawValue {
            endLineStyle = ArrowEndLineType.open
        } else if itemType == ToolboxItemType.arrow && property == ArrowEndLineType.closed.rawValue {
            endLineStyle = ArrowEndLineType.closed
        } else if itemType == ToolboxItemType.shape {
            guard let newShape = ShapeType(rawValue: property) else {
                return
            }
            shape = newShape
        }
    }

    private func updatePropertiesForAnnotation() {
        annotation?.color = color
        annotation?.border?.lineWidth = lineWidth
    }

    // MARK: - Visualize annotation
    private func strokePath() {
        color.setStroke()
        color.setFill()
        path.lineWidth = lineWidth
        if endLineStyle == .closed { path.fill() }

        path.stroke()

        if content == ContentType.image {
            annotatedImageView?.image = currentImage
        }
    }

    private func addAnnotation(_ sybtype: PDFAnnotationSubtype, markUpType: PDFMarkupType) {
        var annotations = [PDFAnnotation]()
        annotatedPDFView?.currentSelection?.selectionsByLine().forEach({ selection in
            if annotatedPDFView != nil, annotatedPDFView!.currentPage != nil {
                annotation = PDFAnnotation(bounds: selection.bounds(for: annotatedPDFView!.currentPage!),
                                           forType: sybtype, withProperties: nil)
                annotation?.markupType = markUpType
                updatePropertiesForAnnotation()
                annotatedPDFView?.currentPage?.addAnnotation(annotation!)
                annotations.append(annotation!)
            }
        })

        guard let page = annotatedPDFView?.currentPage else {
            return
        }
        changesManager.addTextAnnotation(annotations, forPage: page)
    }

    // MARK: - Others
    private func removePreviousVersionOfAnnotation(withPoint point: CGPoint) {
        if content == ContentType.pdf, isAnnotationAdded, annotation != nil {
            annotatedPDFView?.currentPage?.removeAnnotation(annotation!)
        } else if content == ContentType.pdf {
            lastPoint = point
            isAnnotationAdded = true
        } else {
            annotatedImage?.draw(at: CGPoint.zero)
        }
    }
}

// MARK: - Annotating Methods
extension Annotator: Annotating {

    var isThereUnsavedWork: Bool {
        return changesManager.unsavedWork
    }

    func beginAnnotating(atPoint point: CGPoint) {
        if !shouldAnnotate {
            return
        }

        lastPoint = point
        startPoint = point

        if content == ContentType.image {
            guard let size = annotatedImageView?.image?.size else {
                return
            }
            UIGraphicsBeginImageContext(size)
            annotatedImage?.draw(at: CGPoint.zero)
        }
        if choosenItem != ToolboxItemType.arrow {
            beginDrawingWithBezierPath(atPoint: point)
        }

        isAnnotationAdded = false
    }

    func continueAnnotating(atPoint point: CGPoint ) {
        if !shouldAnnotate {
            return
        }

        updateBezierPath(withPoint: point)
        removePreviousVersionOfAnnotation(withPoint: point)

        if content == ContentType.pdf {
            addAnnotationWithCurrentBezierPath()
        }

        strokePath()
        lastPoint = point
    }

    func endAnnotating(atPoint point: CGPoint) {
        if !shouldAnnotate {
            return
        }

        continueAnnotating(atPoint: point)

        if content == ContentType.image {
            let fill = (endLineStyle == .closed)
            changesManager.addInkImageAnnotation(withLines: path, forImage: annotatedImage!, andFill: fill)
            annotatedImage = currentImage
            UIGraphicsEndImageContext()
        } else {
            guard let page = annotatedPDFView?.currentPage, annotation != nil else {
                return
            }
            changesManager.addInkPDFAnnotation(annotation!, forPage: page)
        }
    }

    func reset() {
        if UIGraphicsGetCurrentContext() == nil, let size = annotatedImage?.size {
            UIGraphicsBeginImageContext(size)
        }
        annotatedImage?.draw(at: CGPoint.zero)
        changesManager.reset()
        annotatedImageView?.image = currentImage
        annotatedImage = currentImage
    }

    func save() {
        changesManager.clear()
        if UIGraphicsGetCurrentContext() == nil, let size = annotatedImage?.size {
            UIGraphicsBeginImageContext(size)
        }
        annotatedImage?.draw(at: CGPoint.zero)
        annotatedImageView?.image = currentImage
        annotatedImage = currentImage
    }
}

// MARK: - ToolboxItemDelegate Methods
extension Annotator: ToolboxItemDelegate {
    func didChoose(textAnnotationFromType type: ToolboxItemType) {
        if type == ToolboxItemType.textHighlight {
            addAnnotation(PDFAnnotationSubtype.highlight, markUpType: PDFMarkupType.highlight)
        } else if type == ToolboxItemType.textUnderline {
            addAnnotation(PDFAnnotationSubtype.underline, markUpType: PDFMarkupType.underline)
        } else if type == ToolboxItemType.textStrikeThrough {
            addAnnotation(PDFAnnotationSubtype.strikeOut, markUpType: PDFMarkupType.strikeOut)
        }
    }

    func didChoosePen() {
        choosenItem = ToolboxItemType.pen
    }

    func didChoose(_ option: Int, forToolboxItem type: ToolboxItemType) {
        if type == ToolboxItemType.shape || type == ToolboxItemType.arrow {
            choosenItem = type
        }
        updateProperty(option, fromType: type)
    }

    func didChoose(lineWidth width: Float) {
        lineWidth = CGFloat(width)
    }

    func didChooseColor(_ color: UIColor) {
        self.color = color
    }
}

// MARK: - EditedContentStateDelegate Methods
extension Annotator: EditedContentStateDelegate {
    func didSelectRedo() {
        if UIGraphicsGetCurrentContext() == nil, let size = annotatedImage?.size {
            UIGraphicsBeginImageContext(size)
        }
        color.setStroke()
        color.setFill()
        changesManager.redo {
            annotatedImageView?.image = currentImage
            annotatedImage = currentImage
        }
    }

    func didSelectUndo() {
        if UIGraphicsGetCurrentContext() == nil, let size = annotatedImage?.size {
            UIGraphicsBeginImageContext(size)
        }
        changesManager.undo {
            annotatedImageView?.image = currentImage
            annotatedImage = currentImage
        }
    }
}
