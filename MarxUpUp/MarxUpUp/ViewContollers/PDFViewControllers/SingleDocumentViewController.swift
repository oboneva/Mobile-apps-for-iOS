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
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var toolboxStackView: UIStackView!
    
    var toolboxDelegate: ToolboxStackController?
    
    var document: PDFDocument?
    weak var updateDatabaseDelegate: UpdateDatabaseDelegate?
    
    private var annotator: Annotating!
    private lazy var databaseManager = DatabaseManager()
    
//MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePDFView()
        configurePDFThumbnailView()
        configureCurrentPageLabel()
        
        if annotator == nil {
            annotator = Annotator(forAnnotating: PDFDocumentView)
        }
        
        configureToolboxView()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureWithRecogniser(_:)))
        tapRecognizer.delegate = self
        PDFDocumentView.addGestureRecognizer(tapRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pageChanged(_:)), name: .PDFViewPageChanged, object: PDFDocumentView)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PDFDocumentView.documentView?.isUserInteractionEnabled = true
        PDFDocumentView.isUserInteractionEnabled = false
    }
    
//MARK: - Handle Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
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
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            guard let page = PDFDocumentView.currentPage else {
                return
            }
            let point = PDFDocumentView.convert(touch.location(in: PDFDocumentView), to: page)
            self.annotator.continueAnnotating(atPoint: point)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first {
            guard let page = PDFDocumentView.currentPage else {
                return
            }
            let point = PDFDocumentView.convert(touch.location(in: PDFDocumentView), to: page)
            self.annotator.endAnnotating(atPoint: point)
        }
    }
    
//MARK: - On Button Tap Methods
    @IBAction func onResetTap(_ sender: Any) {
        annotator?.reset()
    }
    
    @IBAction func onSaveTap(_ sender: Any) {
        guard let data = PDFDocumentView.document?.dataRepresentation() else {
            return
        }
        updateDatabaseDelegate?.updatePDF(withData: data)
        annotator.save()
        toolboxStackView?.isHidden = true
    }
    
    @IBAction func onToolboxTap(_ sender: Any) {
        toolboxStackView.superview?.isHidden = !toolboxStackView.isHidden
        toolboxStackView.isHidden = !toolboxStackView.isHidden
    }
    
//MARK: - Configure Views
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
    
    private func configureCurrentPageLabel() {
        currentPageLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        currentPageLabel.layer.cornerRadius = 4
        currentPageLabel.alpha = 1
        view.bringSubviewToFront(currentPageLabel)
        
        updatePageCount()
        fadeLabel()
    }
    
    private func configureToolboxView() {
        toolboxDelegate = ToolboxStackController(withStackView: toolboxStackView, andParentController: self)
        toolboxDelegate?.toolboxItemDelegate = annotator as? ToolboxItemDelegate
        toolboxDelegate?.editedContentStateDelegate = annotator as? EditedContentStateDelegate
        toolboxDelegate?.drawDelegate = self
        toolboxStackView.superview?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        toolboxStackView.superview?.isHidden = true
        toolboxStackView.isHidden = true
        if toolboxStackView.superview != nil {
            view.bringSubviewToFront(toolboxStackView.superview!)
        }
    }
    
//MARK: - Current page label methods
    @objc func pageChanged(_ notif: NSNotification) {
        updatePageCount()
        currentPageLabel.sizeToFit()
        DispatchQueue.main.async {
            self.currentPageLabel.alpha = 1
            self.fadeLabel()
        }
    }
    
    func fadeLabel() {
        UIView.animate(withDuration: 3, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [],
                       animations: {
                        self.currentPageLabel.alpha = 0
        }, completion: nil)
    }
    
    func updatePageCount() {
        let current = 1 + ((document?.index(for: PDFDocumentView.currentPage ?? PDFPage())) ?? 0)
        let all = document?.pageCount ?? 0
        currentPageLabel.text = "  \(current) | \(all)  "
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
        let touch = recognizer.location(in: view)
        if toolboxStackView.superview?.point(inside: touch, with: nil) != nil {
                toolboxStackView?.isHidden = true
                toolboxStackView?.superview?.isHidden = true
        }
        
        if PDFDocumentView.documentView?.point(inside: touch, with: nil) ?? false {
            PDFDocumentView.clearSelection()
            willBeginDrawing()
        }
    }
}

//MARK: - UIPopoverPresentationControllerDelegate Methods
extension SingleDocumentViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

//MARK: - Set Dependacies For Unit Tests
extension SingleDocumentViewController {
    func setDependancies(_ annotator: Annotating){
        self.annotator = annotator
    }
}

