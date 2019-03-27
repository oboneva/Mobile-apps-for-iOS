//
//  RichTextEnumerations.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 19.03.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import UIKit

enum StyleType: String {
    case backgroundColor, foregroundColor, underlineColor,
    underlineStyle, strikethroughColor, strikethroughStyle,
    link, font, strokeColor, strokeWidth, shadow

    var attributedStringKey: NSAttributedString.Key {
        switch self {
        case .backgroundColor:
            return NSAttributedString.Key.backgroundColor
        case .foregroundColor:
            return NSAttributedString.Key.foregroundColor
        case .underlineColor:
            return NSAttributedString.Key.underlineColor
        case .underlineStyle:
            return NSAttributedString.Key.underlineStyle
        case .strikethroughColor:
            return NSAttributedString.Key.strikethroughColor
        case .strikethroughStyle:
            return NSAttributedString.Key.strikethroughStyle
        case .link:
            return NSAttributedString.Key.link
        case .font:
            return NSAttributedString.Key.font
        case .strokeColor:
            return NSAttributedString.Key.strokeColor
        case .strokeWidth:
            return NSAttributedString.Key.strokeWidth
        case .shadow:
            return NSAttributedString.Key.shadow
        }
    }

    var isColor: Bool {
        switch self {
        case .underlineStyle, .strikethroughStyle, .link, .font, .strokeWidth, .shadow:
            return false
        default:
            return true
        }
    }

    static func colorElements() -> [StyleType] {
        return [.backgroundColor, .foregroundColor, .underlineColor, .strikethroughColor, .strokeColor]
    }

    static func lineElements() -> [StyleType] {
        return [.underlineStyle, .strikethroughStyle]
    }

    var isLine: Bool {
        switch self {
        case .underlineStyle, .strikethroughStyle:
            return true
        default:
            return false
        }
    }

    var isAtomic: Bool {
        switch self {
        case .font, .shadow:
            return false
        default:
            return true
        }
    }
}

enum XMLElement: String {
    case string, name, value, style, size, color, blur, offsetHeight, offsetWidth, range
}

enum LineStyle: String {
    case single, thick, double, patternDot, patternDash, patternDashDot, patternDashDotDot, byWord

    var key: NSUnderlineStyle {
        switch self {
        case .single:
            return NSUnderlineStyle.single
        case .thick:
            return NSUnderlineStyle.thick
        case .double:
            return NSUnderlineStyle.double
        case .patternDot:
            return NSUnderlineStyle.patternDot
        case .patternDash:
            return NSUnderlineStyle.patternDash
        case .patternDashDot:
            return NSUnderlineStyle.patternDashDot
        case .patternDashDotDot:
            return NSUnderlineStyle.patternDashDotDot
        case .byWord:
            return NSUnderlineStyle.byWord
        }
    }

    init?(nsunderlineStyle style: NSUnderlineStyle) {
        self.init(rawValue: style.stringValue)
    }
}

extension NSUnderlineStyle {
    var stringValue: String {
        switch self {
        case .single:
            return "single"
        case .thick:
            return "thick"
        case .double:
            return "double"
        case .patternDot:
            return "patternDot"
        case .patternDash:
            return "patternDash"
        case .patternDashDot:
            return "patternDashDot"
        case .patternDashDotDot:
            return "patternDashDotDot"
        case .byWord:
            return "byWord"
        default:
            return "single"
        }
    }
}
