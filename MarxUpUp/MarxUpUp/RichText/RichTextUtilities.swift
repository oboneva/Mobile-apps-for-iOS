//
//  RichTextUtilities.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.03.19.
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
        case .underlineStyle, .strikethroughStyle, .link, .font, .strokeWidth:
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
    case string, name, value, style, size, color, blur, offsetHeight, offsetWidth
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
}

extension UIColor {
    convenience init(fromHEX hex: String) {
        let hex = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hex)

        if hex.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension StringProtocol {
    var firstLowercased: String {
        return prefix(1).lowercased() + dropFirst()
    }
}

extension CGFloat {
    init?(fromDict dict: [String: String], forKey key: String) {
        guard let numberString = dict[key],
            let numberFloat = NumberFormatter().number(from: numberString)?.floatValue else {
                return nil
        }
        self.init(numberFloat)
    }
}
}
