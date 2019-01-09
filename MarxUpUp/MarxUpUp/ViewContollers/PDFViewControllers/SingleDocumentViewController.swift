//
//  SingleDocumentViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 9.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit
import PDFKit

class SingleDocumentViewController: UIViewController {

    @IBOutlet weak var PDFDocumentView: PDFView!
    @IBOutlet weak var PDFDocumentThumbnailView: PDFThumbnailView!
    var toolboxView: UIView?
    var document: PDFDocument?
    weak var updateDatabaseDelegate: UpdateDatabaseDelegate?
    
    private var annotator: Annotating!
    private lazy var databaseManager = DatabaseManager()
    
    //MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePDFView()
        configurePDFThumbnailView()
        
        if annotator == nil {
            annotator = Annotator(forAnnotating: PDFDocumentView)
        }
        
        children.forEach {
            if let toolboxController = $0 as? ToolboxViewController {
                toolboxController.toolboxItemDelegate = annotator as? ToolboxItemDelegate
                toolboxController.editedContentStateDelegate = annotator as? EditedContentStateDelegate
            }
        }
        
        toolboxView?.isHidden = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureWithRecogniser(_:)))
        tapRecognizer.delegate = self
        PDFDocumentView.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PDFDocumentView.documentView?.isUserInteractionEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toolbarController = segue.destination as? ToolbarViewController {
            toolbarController.toolbarButtonsDelegate = self
        }
        else if let toolboxController = segue.destination as? ToolboxViewController {
            toolboxController.contentType = ContentType.PDF
            self.toolboxView = toolboxController.view
            toolboxController.drawDelegate = self
        }
    }
    
    //MARK: - Handle Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            PDFDocumentView.isUserInteractionEnabled = true
        }

        if let touch = touches.first {
            guard let page = PDFDocumentView.currentPage else {
                    return
            }
            let point = PDFDocumentView.convert(touch.location(in: PDFDocumentView), to: page)
            self.annotator.beginAnnotating(atPoint: point)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            guard let page = PDFDocumentView.currentPage else {
                return
            }
            let point = PDFDocumentView.convert(touch.location(in: PDFDocumentView), to: page)
            self.annotator.continueAnnotating(atPoint: point)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            guard let page = PDFDocumentView.currentPage else {
                return
            }
            let point = PDFDocumentView.convert(touch.location(in: PDFDocumentView), to: page)
            self.annotator.endAnnotating(atPoint: point)
        }
    }
    
    //MARK: - Configure PDF Views
    private func configurePDFView() {
        PDFDocumentView.document = document
        PDFDocumentView.displayMode = PDFDisplayMode.singlePage
        PDFDocumentView.displayDirection = PDFDisplayDirection.horizontal
        PDFDocumentView.autoScales = true
        PDFDocumentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    private func configurePDFThumbnailView() {
        PDFDocumentThumbnailView.pdfView = PDFDocumentView
        let thumbnailViewHeight = PDFDocumentThumbnailView.frame.size.height
        PDFDocumentThumbnailView.thumbnailSize = CGSize(width: 100, height: thumbnailViewHeight * 0.8)
        PDFDocumentThumbnailView.layoutMode = PDFThumbnailLayoutMode.horizontal
        PDFDocumentThumbnailView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

//MARK: - ToolbarButtonsDelegate Methods
extension SingleDocumentViewController: ToolbarButtonsDelegate {
    func didSelectAnnotate() {
        PDFDocumentView.documentView?.isUserInteractionEnabled = true
        PDFDocumentView.isUserInteractionEnabled = false
    }
    
    func didSelectToolbox() {
        guard let view = toolboxView else {
            return
        }
        view.isHidden = !view.isHidden
    }
    
    func didSelectReset() {
        annotator?.reset()
    }
    
    func didSelectSave() {
        guard let data = PDFDocumentView.document?.dataRepresentation() else {
            return
        }
        updateDatabaseDelegate?.updatePDF(withData: data)
        
        toolboxView?.isHidden = true
        annotator.reset()
        dismiss(animated: true, completion: nil)
    }
    
    func didSelectGoBack() {
        if annotator.isThereUnsavedWork {
            let alertController = UIAlertController(title: "Unsaved changes", message: "Do you want to save your work before going back?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "Yes", style: .default) { (action) in
                self.didSelectSave()
            })
            alertController.addAction(UIAlertAction(title: "No", style: .destructive) { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            present(alertController, animated: true, completion: nil)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - DrawDelegate Methods
extension SingleDocumentViewController: DrawDelegate {
    func willBeginDrawing() {
        PDFDocumentView.documentView?.isUserInteractionEnabled = true
        PDFDocumentView.isUserInteractionEnabled = false
    }
}

//MARK: - UIGestureRecognizerDelegate Methods
extension SingleDocumentViewController: UIGestureRecognizerDelegate {
    @objc func handleTapGestureWithRecogniser(_ recognizer: UITapGestureRecognizer) {
        guard toolboxView?.isHidden == true else {
            toolboxView?.isHidden = true
            return
        }
//        let point = recognizer.location(in: PDFDocumentView.documentView)
//        guard let annotation = PDFDocumentView.currentPage?.annotation(at: point) else {
//            return
//        }
//        
//        annotation.border = PDFBorder()
//        annotation.border?.style = PDFBorderStyle.dashed
//        annotation.border?.lineWidth = 2
//        let b = annotation.bounds
//        
//        UIColor.black.setStroke()
//        annotation.border?.draw(in: CGRect(x: b.minX - 2, y: b.minY - 2, width: b.width + 2, height: b.height + 2))
        
//        let a = PDFAnnotation(bounds: CGRect(x: 0, y: 0, width: 50, height: 50), forType: PDFAnnotationSubtype.highlight, withProperties: nil)
//        a.isHighlighted = true
    }
}

extension SingleDocumentViewController {
    func setDependancies(_ annotator: Annotating){
        self.annotator = annotator
    }
}
