//
//  StyleModels.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.03.19.
//  Copyright © 2019 Ognyanka Boneva. All rights reserved.
//

import UIKit

class StyleItem {
    let name: NSAttributedString.Key
    let value: Any
    var range = NSRange()

    init(_ name: StyleType, _ value: Any) {
        self.name = name.attributedStringKey
        self.value = value
    }

    convenience init(shadowFromDict dict: [String: String]) {
        let shadow = NSShadow.init()

        if let colorString = dict[XMLElement.color.rawValue] {
            shadow.shadowColor = UIColor(fromHEX: colorString)
        }

        if let offsetH = CGFloat(fromDict: dict, forKey: XMLElement.offsetHeight.rawValue),
            let offsetW = CGFloat(fromDict: dict, forKey: XMLElement.offsetWidth.rawValue) {
            shadow.shadowOffset = CGSize(width: offsetW, height: offsetH)
        }

        if let blur = CGFloat(fromDict: dict, forKey: XMLElement.blur.rawValue) {
            shadow.shadowBlurRadius = blur
        }

        self.init(.shadow, shadow)
    }

    convenience init(fontFromDict dict: [String: String]) {
        if let fontName = dict[XMLElement.name.rawValue],
            let size = CGFloat(fromDict: dict, forKey: XMLElement.size.rawValue) {
            self.init(.font, UIFont(name: fontName, size: size) as Any)
        } else {
            self.init(.font, UIFont.systemFont(ofSize: UIFont.systemFontSize) as Any)
        }
    }
}

extension StyleItem: Equatable {
    ///// cannot compare items' values
    static func == (left: StyleItem, right: StyleItem) -> Bool {
        return left.name == right.name && left.range == right.range
    }
}

class CustomStyle: NSObject {
    var name = ""
    var styleItems = [StyleItem]()
}
