//
//  Enumerations.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 8.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import Foundation

enum ContentType {
    case pdf, image
}

enum ArrowEndLineType: Int {
    case open, closed

    var description: String {
        switch self {
        case .open:
            return "open"
        case .closed:
            return "closed"
        }
    }
}

enum ToolboxItemType: Int {
    case color, shape, pen, arrow, width, textUnderline, textHighlight, textStrikeThrough, undo, redo

    var description: String {
        switch self {
        case .color:
            return "color"
        case .pen:
            return "pen"
        case .arrow:
            return "arrow"
        case .shape:
            return "shape"
        case .width:
            return "width"
        case .textUnderline:
            return "textUnderline"
        case .textHighlight:
            return "textHighlight"
        case .textStrikeThrough:
            return "textStrikeThrough"
        case .undo:
            return "undo"
        case .redo:
            return "redo"
        }
    }

    func dataSource() -> ToolboxItemCollectionDataSource {
        if self == ToolboxItemType.shape {
            return ShapesCollectionViewDataSource()
        } else {
            return ArrowsCollectionViewDataSource()
        }
    }
}

enum ShapeType: Int {
    case circle, roundedRectangle, regularRectangle

    var description: String {
        switch self {
        case .circle:
            return "circle"
        case .roundedRectangle:
            return "roundedRectangle"
        case .regularRectangle:
            return "regularRectangle"
        }
    }
}

enum ImageSort: Int {
    case viral, top, date, none

    var title: String {
        switch self {
        case .viral:
            return "VIRAL"
        case .top:
            return "TOP"
        case .date:
            return "LATEST"
        case .none:
            return "NONE"
        }
    }

    var description: String {
        switch self {
        case .viral:
            return "viral"
        case .top:
            return "top"
        case .date:
            return "time"
        case .none:
            return ""
        }
    }
}

enum SplitError: Error {
    case noResultFound
}
