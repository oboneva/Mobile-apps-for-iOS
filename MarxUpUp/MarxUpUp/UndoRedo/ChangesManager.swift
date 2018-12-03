//
//  ChangesManager.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 29.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit
import PDFKit

class ChangesManager: NSObject {

    private var undoCommands = [Command]()
    private var redoCommands = [Command]()
    
    func redo(withCompletionHandler handler: () -> ()) {
        guard redoCommands.count > 0, let command = redoCommands.popLast() else {
            return
        }
        
        command.execute()
        undoCommands.append(command)
        handler()
    }
    
    func undo(withCompletionHandler handler: () -> ()) {
        guard undoCommands.count > 0, let command = undoCommands.popLast() else {
            return
        }
        
        command.unexecute()
        redoCommands.append(command)
        handler()
    }
    
    func addInkImageAnnotation(withLines lines: UIBezierPath, forImage image: UIImage) {
        let change = ImageInkAnnotation(withLines: lines, forImage: image)
        undoCommands.append(change)
    }
    
    func addInkPDFAnnotation(_ annotation: PDFAnnotation, forPage page: PDFPage) {
        let change = PDFInkAnnotation(annotation, forPDFPage: page)
        undoCommands.append(change)
    }
    
    func addTextAnnotation(_ annotation: [PDFAnnotation], forPage page: PDFPage) {
        let change = TextAnnotation(annotation, forPage: page)
        undoCommands.append(change)
    }
    
    func reset() {
        undoCommands.forEach({ $0.unexecute() })
        redoCommands.removeAll()
    }
}
