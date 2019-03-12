//
//  PDFInkAnnotation.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 3.12.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit
import PDFKit

class PDFInkAnnotation: NSObject {

    let annotation: PDFAnnotation
    let page: PDFPage

    init(_ annotation: PDFAnnotation, forPDFPage page: PDFPage) {
        self.page = page
        self.annotation = annotation
    }
}

// MARK: - Command Methods
extension PDFInkAnnotation: Command {
    func execute() {
        page.addAnnotation(annotation)
    }

    func unexecute() {
        page.removeAnnotation(annotation)
    }
}
