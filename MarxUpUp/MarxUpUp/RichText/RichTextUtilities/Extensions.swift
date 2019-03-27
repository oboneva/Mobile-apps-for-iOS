//
//  Extensions.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 19.03.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import UIKit

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

    var hex: String {
        func toInt(_ float: CGFloat) -> Int {
            return min(255, Int(CGFloat(256) * float))
        }

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        self.getRed(&red, green: &green, blue: &blue, alpha: nil)

        let redInt = toInt(red)
        let greenInt = toInt(green)
        let blueInt = toInt(blue)

        return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
    }
}

extension NSRange {
    var end: Int {
        return self.location + self.length
    }

    var stringValue: String {
        return "\(self.location),\(self.end)"
    }

    init(location start: Int, end endLocation: Int) {
        self.init(location: start, length: endLocation - start)
    }

    init?(fromString string: String) {
        let range = string.split(separator: ",")

        let rangePoints = range.map { (substring) -> Int? in
            Int(substring.trimmingCharacters(in: CharacterSet.whitespaces))
            }.compactMap{ $0 }

        guard rangePoints.count == 2 else { return nil }
        self.init(location: rangePoints[0], end: rangePoints[1])
    }
}

extension Array {
    mutating func popAll(where predicate: (Element) -> (Bool)) -> [Element] {
        var popped = [Element]()

        self = self.compactMap({ (element: Element) -> Element? in
            guard predicate(element) == true else {
                return element
            }

            popped.append(element)
            return nil
        })

        return popped
    }
}

extension StringProtocol {
    var firstLowercased: String {
        return prefix(1).lowercased() + dropFirst()
    }

    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
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

    var stringValue: String {
        return NumberFormatter().string(from: NSNumber(value: Float(self)))!
    }
}
