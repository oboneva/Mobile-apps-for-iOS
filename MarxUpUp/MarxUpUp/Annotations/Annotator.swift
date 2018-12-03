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
    private var choosenItem: ToolboxItemType = ToolboxItemType.Pen
    
    private var color: UIColor = UIColor.black
    private var lineWidth: CGFloat = 2.0
    private var endLineStyle: ArrowEndLineType = ArrowEndLineType.Open
    private var shape: ShapeType = ShapeType.Circle
    private var path: UIBezierPath = UIBezierPath()
    
    var annotation: PDFAnnotation?
    private var isAnnotationAdded: Bool = false
    private var annotatedPDFView: PDFView?
    
    var originalImage: UIImage?
    private var annotatedImage: UIImage?
    private var annotatedImageView: UIImageView?
    private var currentImage: UIImage? {
        get {
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
    private var shouldAnnotate: Bool {
        get {
            return (content == ContentType.Image && annotatedImage != nil && originalImage != nil) ||
                   (content == ContentType.PDF && annotatedPDFView != nil)
        }
    }
    
    private var startPoint: CGPoint!
    private var lastPoint: CGPoint!
    
    private let changesManager = ChangesManager()
    
    init(forAnnotating imageView:UIImageView) {
        content = ContentType.Image
        
        guard imageView.image != nil else {
            print("Error: There is no image to annotate.")
            return
        }
        annotatedImageView = imageView
        originalImage = imageView.image
        annotatedImage = imageView.image
    }
    
    init(forAnnotating PDFView:PDFView) {
        content = ContentType.PDF
        
        guard PDFView.document != nil else {
            print("Error: There is no document to annotate.")
            return
        }
        annotatedPDFView = PDFView
    }
    
    //MARK: - Annotating
    func beginAnnotating(atPoint point:CGPoint) {
        if !shouldAnnotate {
            return
        }
        
        lastPoint = point
        startPoint = point
        
        if content == ContentType.Image {
            guard let size = annotatedImageView?.image?.size else {
                return
            }
            UIGraphicsBeginImageContext(size)
            annotatedImage?.draw(at: CGPoint.zero)
        }
        if choosenItem != ToolboxItemType.Arrow {
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
        
        if content == ContentType.PDF{
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
        
        if content == ContentType.Image {
            changesManager.addInkImageAnnotation(withLines: path, forImage: annotatedImage!)
            annotatedImage = currentImage
            UIGraphicsEndImageContext()
        }
        else {
            guard let page = annotatedPDFView?.currentPage, annotation != nil else {
                return
            }
            changesManager.addInkPDFAnnotation(annotation!, forPage: page)
        }
    }
    
    //MARK: - BezierPaths based annotating
    func beginDrawingWithBezierPath(atPoint point: CGPoint) {
        path = UIBezierPath()
        path.lineWidth = lineWidth
        path.move(to: point)
    }
    
    func updateBezierPath(withPoint point: CGPoint) {
        if choosenItem == ToolboxItemType.Pen {
            path.addLine(to: point)
        }
        else if choosenItem == ToolboxItemType.Shape {
            addShapeWithBezierPath(atPoint: point)
        }
        else if choosenItem == ToolboxItemType.Arrow {
            addArrowWithBezierPath(atPoint: point)
        }
    }
    
    func addArrowWithBezierPath(atPoint point: CGPoint) {
        let capSize = CGFloat(20)
        let rect = CGRect(x: point.x - 10, y: point.y, width: capSize, height: capSize)

        let dx = point.x - startPoint.x
        let dy = point.y - startPoint.y

        let angle = CGFloat(atan2(dy, dx))
        if endLineStyle == .Closed {
            path = ArrowBezierPath.endLineClosed(withRect: rect)
        }
        else {
            path = ArrowBezierPath.endLineOpen(withRect: rect)
        }
        
        path.apply(CGAffineTransform(translationX: -point.x, y: -point.y))
        path.apply(CGAffineTransform(rotationAngle: angle + .pi / 2))
        path.apply(CGAffineTransform(translationX: point.x, y:  point.y))
        
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: point.x, y: point.y))
        
        path.lineWidth = lineWidth
    }
    
    func addShapeWithBezierPath(atPoint point: CGPoint) {
        let shapeRect = Utilities.rectBetween(point, startPoint)
        
        if shape == ShapeType.RegularRectangle {
            path = UIBezierPath(rect: shapeRect)
        }
        else if shape == ShapeType.RoundedRectangle {
            path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 2.0)
        }
        else if shape == ShapeType.Circle {
            path = UIBezierPath(ovalIn: shapeRect)
        }
        
        path.lineWidth = lineWidth
    }
    
    func addAnnotationWithCurrentBezierPath() {
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
    
    //MARK: - Updating properties
    func updateProperty(_ property: Int, fromType itemType: ToolboxItemType) {
        if itemType == ToolboxItemType.Width {
            lineWidth = CGFloat(property)
        }
        else if itemType == ToolboxItemType.Arrow && property == ArrowEndLineType.Open.rawValue {
            endLineStyle = ArrowEndLineType.Open
        }
        else if itemType == ToolboxItemType.Arrow && property == ArrowEndLineType.Closed.rawValue {
            endLineStyle = ArrowEndLineType.Closed
        }
        else if itemType == ToolboxItemType.Shape {
            guard let newShape = ShapeType(rawValue: property) else {
                return
            }
            shape = newShape
        }
    }
    
    func updatePropertiesForAnnotation() {
        annotation?.color = color
        annotation?.border?.lineWidth = lineWidth
    }
    
    //MARK: - Visualize annotation
    func strokePath() {
        color.setStroke()
        color.setFill()
        path.lineWidth = lineWidth;
        if endLineStyle == .Closed { path.fill() }
        
        path.stroke()
        
        if content == ContentType.Image {
            annotatedImageView?.image = currentImage
        }
    }
    
    func addAnnotation(_ sybtype: PDFAnnotationSubtype, markUpType: PDFMarkupType) {
        var annotations = [PDFAnnotation]()
        annotatedPDFView?.currentSelection?.selectionsByLine().forEach({ selection in
            if annotatedPDFView != nil, annotatedPDFView!.currentPage != nil {
                annotation = PDFAnnotation(bounds: selection.bounds(for: annotatedPDFView!.currentPage!), forType: sybtype, withProperties: nil)
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
    
    //MARK: - Others
    func removePreviousVersionOfAnnotation(withPoint point: CGPoint) {
        if content == ContentType.PDF, isAnnotationAdded, annotation != nil {
            annotatedPDFView?.currentPage?.removeAnnotation(annotation!)
        }
        else if content == ContentType.PDF {
            lastPoint = point
            isAnnotationAdded = true
        }
        else {
            annotatedImage?.draw(at: CGPoint.zero)
        }
    }
    
    func reset() {
        changesManager.reset()
    }
}

//MARK: - ToolboxItemDelegate Methods
extension Annotator: ToolboxItemDelegate {
    func didChoose(textAnnotationFromType type : ToolboxItemType) {
        if type == ToolboxItemType.TextHighlight {
            addAnnotation(PDFAnnotationSubtype.highlight, markUpType: PDFMarkupType.highlight)
        }
        else if type == ToolboxItemType.TextUnderline {
            addAnnotation(PDFAnnotationSubtype.underline, markUpType: PDFMarkupType.underline)
        }
        else if type == ToolboxItemType.TextStrikeThrough {
            addAnnotation(PDFAnnotationSubtype.strikeOut, markUpType: PDFMarkupType.strikeOut)
        }
    }
    
    func didChoosePen() {
        choosenItem = ToolboxItemType.Pen
    }
    
    func didChoose(_ option : Int, forToolboxItem type: ToolboxItemType) {
        if type == ToolboxItemType.Shape || type == ToolboxItemType.Arrow {
            choosenItem = type
        }
        updateProperty(option, fromType: type)
    }
    
    func didChoose(lineWidth width : Float) {
        lineWidth = CGFloat(width)
    }
    
    func didChooseColor(_ color: UIColor) {
        self.color = color
    }
}

//MARK: - EditedContentStateDelegate Methods
extension Annotator: EditedContentStateDelegate {
    func didSelectRedo() {
        if UIGraphicsGetCurrentContext() == nil, let size = annotatedImage?.size {
            UIGraphicsBeginImageContext(size)
        }
        changesManager.redo() {
            annotatedImageView?.image = currentImage
        }
    }
    
    func didSelectUndo() {
        if UIGraphicsGetCurrentContext() == nil, let size = annotatedImage?.size {
            UIGraphicsBeginImageContext(size)
        }
        changesManager.undo() {
            annotatedImageView?.image = currentImage
        }
    }
}
