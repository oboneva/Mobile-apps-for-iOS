//
//  Enumerations.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 8.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import Foundation

enum ContentType {
    case PDF, Image
}

enum ArrowEndLineType: Int {
    case Open, Closed
    
    var description: String {
        switch self {
        case .Open:
            return "open"
        case .Closed:
            return "closed"
        }
    }
}

enum ToolboxItemType {
    case Color, Shape, Pen, Arrow, Width, TextUnderline, TextHighlight, TextStrikeThrough, Undo, Redo
    
    var description: String {
        switch self {
        case .Color:
            return "color"
        case .Pen:
            return "pen"
        case .Arrow:
            return "arrow"
        case .Shape:
            return "shape"
        case .Width:
            return "width"
        case .TextUnderline:
            return "textUnderline"
        case .TextHighlight:
            return "textHighlight"
        case .TextStrikeThrough:
            return "textStrikeThrough"
        case .Undo:
            return "undo"
        case .Redo:
            return "redo"
        }
    }
    
    func dataSource() -> ToolboxItemCollectionDataSource {
        if self == ToolboxItemType.Shape {
            return ShapesCollectionViewDataSource()
        }
        else {
            return ArrowsCollectionViewDataSource()
        }
    }
}

enum ShapeType: Int {
    case Circle, RoundedRectangle, RegularRectangle
    
    var description: String {
        switch self {
        case .Circle:
            return "circle"
        case .RoundedRectangle:
            return "roundedRectangle"
        case .RegularRectangle:
            return "regularRectangle"
        }
    }
}

enum ImageSort: Int {
    case Viral, Top, Date, None
    
    var title: String {
        switch self {
        case .Viral:
            return "VIRAL"
        case .Top:
            return "TOP"
        case .Date:
            return "LATEST"
        case .None:
            return "NONE"
        }
    }
    
    var description: String {
        switch self {
        case .Viral:
            return "Viral"
        case .Top:
            return "Top"
        case .Date:
            return "Date"
        case .None:
            return ""
        }
    }
}
