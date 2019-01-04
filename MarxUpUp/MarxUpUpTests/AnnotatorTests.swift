//
//  AnnotatorTests.swift
//  MarxUpUpTests
//
//  Created by Ognyanka Boneva on 5.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import XCTest
@testable import MarxUpUp
import UIKit
import PDFKit

class AnnotatorTests: XCTestCase {

    let points = [CGPoint.zero, CGPoint(x: 10, y: 10), CGPoint(x: 15, y: 15)]
    let morePoints = [CGPoint(x: 10, y: 10), CGPoint(x: 10, y: 20), CGPoint(x: 10, y: 30)]
    let color = UIColor.black
    let lineWidth = CGFloat(3.0)
    
    let imageAnnotator: Annotator = {
        let image = UIImage(named: "test-image")
        let imageView = UIImageView(image: image)
        let annotator = Annotator(forAnnotating: imageView)
        annotator.didChooseColor(UIColor.black)
        annotator.didChoose(lineWidth: 3.0)
        return annotator
    }()
    
    let pdfAnnotator: Annotator = {
        let pdf = PDFDocument(url: URL(fileURLWithPath: Bundle.main.path(forResource: "test-document", ofType: "pdf") ?? ""))
        let pdfView = PDFView.init(frame: CGRect(x: 0, y: 0, width: 375, height: 469))
        
        pdfView.document = pdf
        pdfView.displayMode = PDFDisplayMode.singlePage
        pdfView.displayDirection = PDFDisplayDirection.horizontal
        pdfView.autoScales = true
        
        let annotator = Annotator(forAnnotating: pdfView)
        annotator.didChooseColor(UIColor.black)
        annotator.didChoose(lineWidth: 3.0)
        return annotator
    }()
    
    func annotateImage() {
        imageAnnotator.beginAnnotating(atPoint: points[0])
        imageAnnotator.continueAnnotating(atPoint: points[1])
        imageAnnotator.endAnnotating(atPoint: points[2])
    }
    
    func annotatePDF() {
        pdfAnnotator.beginAnnotating(atPoint: points[0])
        pdfAnnotator.continueAnnotating(atPoint: points[1])
        pdfAnnotator.endAnnotating(atPoint: points[2])
    }
    
    func annotateMore() {
        imageAnnotator.beginAnnotating(atPoint: morePoints[0])
        imageAnnotator.continueAnnotating(atPoint: morePoints[1])
        imageAnnotator.endAnnotating(atPoint: morePoints[2])
    }
    
    func customAnnotateWithDefaultColorAndLineWidth(_ image: UIImage, withPath path: UIBezierPath) -> UIImage? {
        return customAnnotate(image, withPath: path, color, andLineWidth: lineWidth)
    }
    
    func customAnnotate(_ image: UIImage, withPath path: UIBezierPath, _ color: UIColor, andLineWidth width: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: CGPoint.zero)
        color.setStroke()
        path.lineWidth = width
        path.stroke()
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    
    func testAnnotatorShouldNotAnnotateEmptyImageView() {
        imageAnnotator.didChoosePen()
        imageAnnotator.annotatedImage = nil
        annotateImage()
        
        let result = imageAnnotator.annotatedImage
        XCTAssertEqual(nil, result?.pngData())
    }
    
    func testAnnotatorImageInkPen() {
        imageAnnotator.didChoosePen()
        annotateImage()
        
        guard var expected = imageAnnotator.originalImage else {
            XCTFail("Error: No image")
            return
        }
        let path = UIBezierPath()
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])
        expected = customAnnotateWithDefaultColorAndLineWidth(expected, withPath: path) ?? UIImage()
        
        XCTAssertEqual(imageAnnotator.annotatedImage?.pngData(), expected.pngData())
    }

    func testAnnotatorImageInkShapeOval() {
        imageAnnotator.didChoose(ShapeType.Circle.rawValue, forToolboxItem: .Shape)
        annotateImage()
        let result = imageAnnotator.annotatedImage
        
        guard var expected = imageAnnotator.originalImage else {
            XCTFail("Error: No image to annotate")
            return
        }
        let path = UIBezierPath(ovalIn: CGRect(x: points[0].x, y: points[0].y, width: points[2].x, height: points[2].y))
        
        expected = customAnnotateWithDefaultColorAndLineWidth(expected, withPath: path) ?? UIImage()
        XCTAssertEqual(result?.pngData(), expected.pngData())
    }
    
    func testAnnotatorImageInkShapeRectangle() {
        imageAnnotator.didChoose(ShapeType.RegularRectangle.rawValue, forToolboxItem: .Shape)
        annotateImage()
        let result = imageAnnotator.annotatedImage
        
        guard var expected = imageAnnotator.originalImage else {
            XCTFail("Error: No image to annotate.")
            return
        }
        
        let path = UIBezierPath(rect: CGRect(x: points[0].x, y: points[0].y, width: points[2].x, height: points[2].y))
        expected = customAnnotateWithDefaultColorAndLineWidth(expected, withPath: path) ?? UIImage()
        XCTAssertEqual(result?.pngData(), expected.pngData())
    }
    
    func testAnnotatorImageInkShapeRoundedRectangle() {
        imageAnnotator.didChoose(ShapeType.RoundedRectangle.rawValue, forToolboxItem: .Shape)
        annotateImage()
        let result = imageAnnotator.annotatedImage
        
        guard var expected = imageAnnotator.originalImage else {
            XCTFail("Error: No image to annotate.")
            return
        }
        
        let path = UIBezierPath(roundedRect: CGRect(x: points[0].x, y: points[0].y, width: points[2].x, height: points[2].y), cornerRadius: 2)
        expected = customAnnotateWithDefaultColorAndLineWidth(expected, withPath: path) ?? UIImage()
        XCTAssertEqual(result?.pngData(), expected.pngData())
    }
    
    func testAnnotatorImageInkArrowOpen() {
        imageAnnotator.didChoose(ArrowEndLineType.Open.rawValue, forToolboxItem: .Arrow)
        annotateImage()
        let result = imageAnnotator.annotatedImage
        
        guard var expected = imageAnnotator.originalImage else {
            XCTFail("Error: No image to annotate")
            return
        }
        
        let path = ArrowBezierPath.endLine(atPoint: points[2], fromType: .Open)
        let angle = Utilities.angleBetweenPoint(points[2], andOtherPoint: points[0])
        Utilities.rotateBezierPath(path, aroundPoint: points[2], withAngle: angle)
        path.move(to: points[0])
        path.addLine(to: points[2])
        
        expected = customAnnotateWithDefaultColorAndLineWidth(expected, withPath: path) ?? UIImage()
        XCTAssertEqual(expected.pngData(), result?.pngData())
    }
    
    func testAnnotatorImageInkArrowClosed() {
        imageAnnotator.didChoose(ArrowEndLineType.Closed.rawValue, forToolboxItem: .Arrow)
        annotateImage()
        let result = imageAnnotator.annotatedImage
        
        guard var expected = imageAnnotator.originalImage else {
            XCTFail("Error: No image to annotate")
            return
        }
        
        let path = ArrowBezierPath.endLine(atPoint: points[2], fromType: .Closed)
        let angle = Utilities.angleBetweenPoint(points[2], andOtherPoint: points[0])
        Utilities.rotateBezierPath(path, aroundPoint: points[2], withAngle: angle)
        path.move(to: points[0])
        path.addLine(to: points[2])
        
        
        UIGraphicsBeginImageContext(expected.size)
        expected.draw(at: CGPoint.zero)
        color.setStroke()
        color.setFill()
        path.lineWidth = lineWidth
        path.stroke()
        path.fill()
        expected = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()

        XCTAssertEqual(expected.pngData(), result?.pngData())
    }
    
    func testAnnotatorImageLineWidth() {
        let width = Float(10)
        imageAnnotator.didChoosePen()
        imageAnnotator.didChoose(lineWidth: width)
        annotateImage()
        let result = imageAnnotator.annotatedImage
        
        guard var expected = imageAnnotator.originalImage else {
            XCTFail("Error: No image to annotate")
            return
        }
        
        let path = UIBezierPath()
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])
        
        expected = customAnnotate(expected, withPath: path, color, andLineWidth: CGFloat(width)) ?? UIImage()
        XCTAssertEqual(expected.pngData(), result?.pngData())
    }
    
    func testAnnotatorImageColor() {
        let color = UIColor.purple
        imageAnnotator.didChooseColor(color)
        imageAnnotator.didChoosePen()
        annotateImage()
        let result = imageAnnotator.annotatedImage
        
        guard var expected = imageAnnotator.originalImage else {
            XCTFail("Error: No image to annotate")
            return
        }
        
        let path = UIBezierPath()
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])
        
        expected = customAnnotate(expected, withPath: path, color, andLineWidth: lineWidth) ?? UIImage()
        XCTAssertEqual(expected.pngData(), result?.pngData())
    }
    
    func testAnnotatorImageRedo() {
        imageAnnotator.didChoosePen()
        annotateImage()
        annotateMore()
        
        let expected = imageAnnotator.annotatedImage
        imageAnnotator.didSelectUndo()
        imageAnnotator.didSelectRedo()
        let result = imageAnnotator.annotatedImage
        
        XCTAssertEqual(expected?.pngData(), result?.pngData())
    }
    
    func testAnnotatorPDFInkPen() {
        pdfAnnotator.didChoosePen()
        annotatePDF()
        let page = pdfAnnotator.annotatedPDFView?.currentPage
        let result = page?.annotations.last
        
        let path = UIBezierPath()
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])
        path.lineWidth = lineWidth
    
        XCTAssert(result?.paths?.count == 1)
        XCTAssertEqual(result?.paths?.first, path)
        XCTAssert(result?.color == color)
    }
    
    func testAnnotatorPDFInkShape() {
        pdfAnnotator.didChoose(ShapeType.Circle.rawValue, forToolboxItem: .Shape)
        annotatePDF()
        let page = pdfAnnotator.annotatedPDFView?.currentPage
        let result = page?.annotations.last
        
        let rect = Utilities.rectBetween(points[0], points[2])
        let path = UIBezierPath(ovalIn: rect)
        path.lineWidth = lineWidth
        
        XCTAssert(result?.paths?.count == 1)
        XCTAssertEqual(result?.paths?.first, path)
        XCTAssert(result?.color == color)
    }
    
    func testAnnotatorPDFInkArrow() {
        pdfAnnotator.didChoose(ArrowEndLineType.Closed.rawValue, forToolboxItem: .Arrow)
        annotatePDF()
        let page = pdfAnnotator.annotatedPDFView?.currentPage
        let result = page?.annotations.last
        
        let path = ArrowBezierPath.endLine(atPoint: points[2], fromType: .Closed)
        let angle = Utilities.angleBetweenPoint(points[2], andOtherPoint: points[0])
        Utilities.rotateBezierPath(path, aroundPoint: points[2], withAngle: angle)
        path.move(to: points[0])
        path.addLine(to: points[2])
        path.lineWidth = lineWidth
        
        XCTAssert(result?.paths?.count == 1)
        XCTAssertEqual(result?.paths?.first, path)
        XCTAssert(result?.color == color)
    }
    
    func testAnnotatorPDFUnderline() {
        guard let page = pdfAnnotator.annotatedPDFView?.currentPage else {
            XCTFail("Error: No document for annotating")
            return
        }
        let selection = pdfAnnotator.annotatedPDFView?.document?.selection(from: page, atCharacterIndex: 0, to: page, atCharacterIndex: 20)
        pdfAnnotator.annotatedPDFView?.currentSelection = selection
        pdfAnnotator.didChoose(textAnnotationFromType: .TextUnderline)
        let result = page.annotations.last
        
        XCTAssertEqual(result?.color, color)
        XCTAssertEqual(result?.bounds, selection?.bounds(for: page))
    }
    
    func testAnnotatorPDFHighlight() {
        guard let page = pdfAnnotator.annotatedPDFView?.currentPage else {
            XCTFail("Error: No document for annotating")
            return
        }
        let selection = pdfAnnotator.annotatedPDFView?.document?.selection(from: page, atCharacterIndex: 0, to: page, atCharacterIndex: 20)
        pdfAnnotator.annotatedPDFView?.currentSelection = selection
        pdfAnnotator.didChoose(textAnnotationFromType: .TextHighlight)
        let result = page.annotations.last
        
        XCTAssertEqual(result?.color, color)
        XCTAssertEqual(result?.bounds, selection?.bounds(for: page))
    }
    
    func testAnnotatorPDFStrikeOut() {
        guard let page = pdfAnnotator.annotatedPDFView?.currentPage else {
            XCTFail("Error: No document for annotating")
            return
        }
        let selection = pdfAnnotator.annotatedPDFView?.document?.selection(from: page, atCharacterIndex: 0, to: page, atCharacterIndex: 20)
        pdfAnnotator.annotatedPDFView?.currentSelection = selection
        pdfAnnotator.didChoose(textAnnotationFromType: .TextStrikeThrough)
        let result = page.annotations.last
        
        XCTAssertEqual(result?.color, color)
        XCTAssertEqual(result?.bounds, selection?.bounds(for: page))
    }
}
