//
//  TextAnnotation.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 30.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit
import PDFKit

class TextAnnotation: NSObject {
    var annotation = [PDFAnnotation]()
    var page: PDFPage

    init(_ annotation: [PDFAnnotation], forPage page: PDFPage) {
        self.annotation = annotation
        self.page = page
    }
}

// MARK: - Command Methods
extension TextAnnotation: Command {
    func unexecute() {
        annotation.forEach({ page.removeAnnotation($0) })
    }

    func execute() {
        annotation.forEach({ page.addAnnotation($0) })
    }
}
